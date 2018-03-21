<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Accounts_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }
	//=============delete chart account===================
	public function deleteChartAccount($id){
		$q = $this->db->delete('gl_charts', array('accountcode' => $id));
		if($q){
			return true;
		} else{
			return false;
		}
	}

    public function getProductNames($term, $warehouse_id, $limit = 5)
    {
        $this->db->select('products.id, code, name, warehouses_products.quantity, cost, tax_rate, type, tax_method')
            ->join('warehouses_products', 'warehouses_products.product_id=products.id', 'left')
            ->group_by('products.id');
        if ($this->Settings->overselling) {
            $this->db->where("type = 'standard' AND (name LIKE '%" . $term . "%' OR code LIKE '%" . $term . "%' OR  concat(name, ' (', code, ')') LIKE '%" . $term . "%')");
        } else {
            $this->db->where("type = 'standard' AND warehouses_products.warehouse_id = '" . $warehouse_id . "' AND warehouses_products.quantity > 0 AND "
                . "(name LIKE '%" . $term . "%' OR code LIKE '%" . $term . "%' OR  concat(name, ' (', code, ')') LIKE '%" . $term . "%')");
        }
        $this->db->limit($limit);
        $q = $this->db->get('products');
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
    }
	/*
    public function getAllcharts() {
        $q = $this->db->select();
		$q = $this->db->from('erp_gl_charts');
		$query=$this->db->get();
		return $query->result_array();
    }*/
	public function getAllcharts() {
        $q = $this->db->get('warehouses');
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
    public function getWHProduct($id)
    {
        $this->db->select('products.id, code, name, warehouses_products.quantity, cost, tax_rate')
            ->join('warehouses_products', 'warehouses_products.product_id=products.id', 'left')
            ->group_by('products.id');
        $q = $this->db->get_where('products', array('warehouses_products.product_id' => $id), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }

        return FALSE;
    }

    public function addTransfer($data = array(), $items = array())
    {
        $status = $data['status'];
        if ($this->db->insert('transfers', $data)) {
            $transfer_id = $this->db->insert_id();
            if ($this->site->getReference('to') == $data['transfer_no']) {
                $this->site->updateReference('to');
            }
            foreach ($items as $item) {
                $item['transfer_id'] = $transfer_id;
                if ($status == 'completed') {
                    $item['date'] = date('Y-m-d');
                    $item['warehouse_id'] = $data['to_warehouse_id'];
                    $item['status'] = 'received';
                    $this->db->insert('purchase_items', $item);
                } else {
                    $this->db->insert('transfer_items', $item);
                }

                if ($status == 'sent' || $status == 'completed') {
                    $this->syncTransderdItem($item['product_id'], $data['from_warehouse_id'], $item['quantity'], $item['option_id']);
                }
            }

            return true;
        }
        return false;
    }

    public function updateTransfer($id, $data = array(), $items = array())
    {
        $ostatus = $this->resetTransferActions($id);
        $status = $data['status'];
        if ($this->db->update('transfers', $data, array('id' => $id))) {
            $tbl = $ostatus == 'completed' ? 'purchase_items' : 'transfer_items';
            $this->db->delete($tbl, array('transfer_id' => $id));

            foreach ($items as $item) {
                $item['transfer_id'] = $id;
                if ($status == 'completed') {
                    $item['date'] = date('Y-m-d');
                    $item['warehouse_id'] = $data['to_warehouse_id'];
                    $item['status'] = 'received';
                    $this->db->insert('purchase_items', $item);
                } else {
                    $this->db->insert('transfer_items', $item);
                }

                $status = $data['status'];
                if ($status == 'sent' || $status == 'completed') {
                    $this->syncTransderdItem($item['product_id'], $data['from_warehouse_id'], $item['quantity'], $item['option_id']);
                }

            }

            return true;
        }

        return false;
    }

    public function getProductWarehouseOptionQty($option_id, $warehouse_id)
    {
        $q = $this->db->get_where('warehouses_products_variants', array('option_id' => $option_id, 'warehouse_id' => $warehouse_id), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }
        return FALSE;
    }

    public function getProductByCategoryID($id)
    {

        $q = $this->db->get_where('products', array('category_id' => $id), 1);
        if ($q->num_rows() > 0) {
            return true;
        }

        return FALSE;
    }
	
	public function getAccountSections(){
		$this->db->select("sectionid,sectionname");
		$section = $this->db->get("gl_sections");
		if($section->num_rows() > 0){
			return $section->result_array();	
		}
		return false;
	}
	
	public function getSubAccounts($section_code){
		$this->db->select('accountcode as id, accountname as text');
        $q = $this->db->get_where("gl_charts", array('sectionid' => $section_code));
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }

            return $data;
        }

        return FALSE;
	}
	
	public function addChartAccount($data){
		//$this->erp->print_arrays($data);
		if ($this->db->insert('gl_charts', $data)) {
            return true;
        }
        return false;
	}
	
	public function updateChartAccount($id,$data){
		//$this->erp->print_arrays($data);
		$this->db->where('accountcode', $id);
		$q=$this->db->update('gl_charts', $data);
        if ($q) {
            return true;
        }
        return false;
	}

    public function getProductQuantity($product_id, $warehouse = DEFAULT_WAREHOUSE)
    {
        $q = $this->db->get_where('warehouses_products', array('product_id' => $product_id, 'warehouse_id' => $warehouse), 1);
        if ($q->num_rows() > 0) {
            return $q->row_array(); //$q->row();
        }
        return FALSE;
    }

    public function insertQuantity($product_id, $warehouse_id, $quantity)
    {
        if ($this->db->insert('warehouses_products', array('product_id' => $product_id, 'warehouse_id' => $warehouse_id, 'quantity' => $quantity))) {
            $this->site->syncProductQty($product_id, $warehouse_id);
            return true;
        }
        return false;
    }

    public function updateQuantity($product_id, $warehouse_id, $quantity)
    {
        if ($this->db->update('warehouses_products', array('quantity' => $quantity), array('product_id' => $product_id, 'warehouse_id' => $warehouse_id))) {
            $this->site->syncProductQty($product_id, $warehouse_id);
            return true;
        }
        return false;
    }
	
	public function updateSetting($data){
		if ($this->db->update('account_settings', $data)) {
            return true;
        }
        return false;
	}

    public function getProductByCode($code)
    {

        $q = $this->db->get_where('products', array('code' => $code), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }

        return FALSE;
    }

    public function getProductByName($name)
    {

        $q = $this->db->get_where('products', array('name' => $name), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }

        return FALSE;
    }
	
	public function getChartAccountByID($id){
		$this->db->select('gl_charts.accountcode,gl_charts.accountname,gl_charts.parent_acc,gl_charts.sectionid,gl_sections.sectionname, bank ');
		$this->db->from('gl_charts');
		$this->db->join('gl_sections', 'gl_sections.sectionid=gl_charts.sectionid','INNER');
		$this->db->where('gl_charts.accountcode' , $id);
		$q = $this->db->get();
        if ($q->num_rows() > 0) {
            return $q->row();
        }
        return FALSE;
	}
	
	public function getAllChartAccount(){
		$this->db->select('gl_charts.accountcode,gl_charts.accountname,gl_charts.parent_acc,gl_charts.sectionid');
		$this->db->from('gl_charts');
		$q = $this->db->get();
        if ($q->num_rows() > 0) {
            return $q->result();
        }

        return FALSE;
	}
	
	public function getAllChartAccountIn($section_id){
		$q = $this->db->query("SELECT
									accountcode,
									accountname,
									parent_acc,
									sectionid
								FROM
									erp_gl_charts
								WHERE
									sectionid IN ($section_id)");
		
        if ($q->num_rows() > 0) {
            return $q->result();
        }
        return FALSE;
	}
	
	public function getCustomers()
    {
        $q = $this->db->query("SELECT
									id, company
								FROM
									erp_companies
								WHERE
									group_name = 'biller'
								");
		
        if ($q->num_rows() > 0) {
            return $q->result();
        }
        return FALSE;
    }
	
	public function getAllChartAccounts(){
		$q = $this->db->query("SELECT
									accountcode,
									accountname,
									parent_acc,
									sectionid
								FROM
									erp_gl_charts
								");
		
        if ($q->num_rows() > 0) {
            return $q->result();
        }
        return FALSE;
	}
	
	public function getBillers()
    {
		$this->db->select('company');
		$this->db->from('companies');
		$this->db->join('account_settings', 'account_settings.biller_id=companies.id');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getSalename()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_sale=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getsalediscount()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_sale_discount=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getsale_tax()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_sale_tax=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getreceivable()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_receivable=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getpurchases()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_purchase=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getGLYearMonth(){
		$query = $this->db->select("MIN(YEAR(tran_date)) AS min_year, MIN(MONTH(tran_date)) AS min_month")
				->get('gl_trans');
		if($query->num_rows() > 0){
			return $query->row();
		}
		return false;
	}
	
	
	public function getpurchase_tax()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_purchase_tax=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	
	public function getpurchasediscount()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_purchase_discount=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getpayable()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_payable=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_sale_freights()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_sale_freight=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_purchase_freights()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_purchase_freight=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
    
	public function getstocks()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_stock=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getstock_adjust()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_stock_adjust=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_cost()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_cost=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getpayrolls()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_payroll=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_cash()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_cash=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getcredit_card()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_credit_card=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_sale_deposit()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_sale_deposit=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	public function get_purchase_deposit()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_purchase_deposit=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getcheque()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_cheque=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_loan()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_loan=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_retained_earning()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_retained_earnings=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function get_cost_of_variance()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_cost_variant=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getgift_card()
    {
		$this->db->select('accountname');
		$this->db->from('account_settings');
		$this->db->join('gl_charts', 'account_settings.default_gift_card=gl_charts.accountcode');
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }
	
	public function getAllChartAccountBank(){
		$this->db->select('gl_charts.accountcode,gl_charts.accountname,gl_charts.parent_acc,gl_charts.sectionid');
		$this->db->from('gl_charts');
		$this->db->where('bank', 1);
		$q = $this->db->get();
        if ($q->num_rows() > 0) {
            return $q->result();
        }

        return FALSE;
	}
	
	public function updateJournal($rows) {
		$ids = '';
		$ref = '';
		//$this->erp->print_arrays($rows);
		foreach($rows as $data){
			$gl_chart = $this->getChartAccountByID($data['account_code']);	
			if($gl_chart > 0){
				$data['sectionid'] = $gl_chart->sectionid;
				$data['narrative'] = $gl_chart->accountname;
			}
			$ref = $data['reference_no'];
			
			if($data['tran_id'] != 0){
				$this->db->where('reference_no', $data['reference_no'])->where('tran_id' , $data['tran_id']);
				$q = $this->db->update('gl_trans', $data);
				if ($q) {
					if($gl_chart->bank == 1){
						$payment = array(
							'date' => $data['tran_date'],
							'transaction_id' => $data['tran_no'],
							'amount' => $data['amount'],
							'reference_no' => $data['reference_no'],
							'paid_by' => $data['narrative'],
							'note' => $data['narrative'],
							'type' => 'received',
							'created_by' => $this->session->userdata('user_id')
						);
						//$this->db->update('payments', $payment, array('transaction_id' => $data['tran_no']));
					}
					$ids .= $data['tran_id'] . ',';
				}
			}else{
				if($this->db->insert('gl_trans', $data)) {
					$tran_id = $this->db->insert_id();
					if($gl_chart->bank == 1){
						$payment = array(
							'date' => $data['tran_date'],
							'transaction_id' => $data['tran_no'],
							'amount' => $data['amount'],
							'reference_no' => $data['reference_no'],
							'paid_by' => $data['narrative'],
							'note' => $data['narrative'],
							'type' => 'received',
							'created_by' => $this->session->userdata('user_id')
						);
						$this->db->insert('payments', $payment);
					}
					$ids .= $tran_id . ',';
				}
			}
		}
	//	$ids = rtrim($ids, ',');
	//	$ids_arr = explode(',', $ids);
	//	$this->db->where_not_in('tran_id', $ids_arr);
	//	$this->db->where('reference_no', $ref);
	//	$this->db->delete('gl_trans'); 
	}
	
	public function addJournal($rows){
		foreach($rows as $data){
			$gl_chart = $this->getChartAccountByID($data['account_code']);
			if($gl_chart > 0){
				$data['sectionid'] = $gl_chart->sectionid;
				$data['narrative'] = $gl_chart->accountname;
			}
			if ($this->db->insert('gl_trans', $data)) {
				$tran_id = $this->db->insert_id();
				if($gl_chart->bank == 1){
					$payment = array(
						'date' => $data['tran_date'],
						'transaction_id' => $data['tran_no'],
						'amount' => $data['amount'],
						'reference_no' => $this->site->getReference('tr'),
						'paid_by' => $data['narrative'],
						'note' => '',
						'type' => 'received',
						'created_by' => $this->session->userdata('user_id')
					);
					$this->db->insert('payments', $payment);
				}
			}
		}
	}
	
	public function getJournalByTranNoTranID($tran_id, $tran_no){
		$q = $this->db->get_where('gl_trans', array('tran_id' => $tran_id, 'tran_no' => $tran_no), 1);
		if($q->num_rows() > 0){
			$row = $q->row();
			return $row->tr;
		}
		return FALSE;
	}
	
	public function getTranNo(){
		/*
		$this->db->query("UPDATE erp_order_ref
							SET tr = tr + 1
							WHERE
							DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')");
		*/
		/*
		$q = $this->db->query("SELECT tr FROM erp_order_ref
									WHERE DATE_FORMAT(date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')");
									*/

		$this->db->select('(COALESCE (MAX(tran_no), 0) + 1) AS tr');
		$q = $this->db->get('gl_trans');
		if($q->num_rows() > 0){
			$row = $q->row();
			return $row->tr;
		}
		return FALSE;
	}
	
	public function getTranNoByRef($ref){
		$this->db->select('tran_no');
		$this->db->where('reference_no', $ref);
		$q = $this->db->get('gl_trans');
		if($q->num_rows() > 0){
			$row = $q->row();
			return $row->tran_no;
		}
		return FALSE;
	}
	
	public function getTranTypeByRef($ref){
		$this->db->select('tran_type');
		$this->db->where('reference_no', $ref);
		$q = $this->db->get('gl_trans');
		if($q->num_rows() > 0){
			$row = $q->row();
			return $row->tran_type;
		}
		return FALSE;
	}
	
	public function deleteJournalByRef($ref){
		$q = $this->db->delete('gl_trans', array('reference_no' => $ref));
		if($q){
			return true;
		}
		return false;
	}
	
	public function getJournalByRef($ref){
		$this->db->select('gl_trans.*, (IF(erp_gl_trans.amount > 0, erp_gl_trans.amount, null)) as debit, 
							(IF(erp_gl_trans.amount < 0, abs(erp_gl_trans.amount), null)) as credit');
		$q = $this->db->get_where('gl_trans', array('reference_no' => $ref));
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
	}
	
	public function getJournalByTranNo($tran_no){
		$this->db->select('gl_trans.*, (IF(erp_gl_trans.amount > 0, erp_gl_trans.amount, null)) as debit, 
							(IF(erp_gl_trans.amount < 0, abs(erp_gl_trans.amount), null)) as credit');
		$q = $this->db->get_where('gl_trans', array('tran_no' => $tran_no));
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
	}
	
    public function getTransferByID($id)
    {

        $q = $this->db->get_where('transfers', array('id' => $id), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }

        return FALSE;
    }

    public function getAllTransferItems($transfer_id, $status)
    {
        if ($status == 'completed') {
            $this->db->select('purchase_items.*, product_variants.name as variant')
                ->from('purchase_items')
                ->join('product_variants', 'product_variants.id=purchase_items.option_id', 'left')
                ->group_by('purchase_items.id')
                ->where('transfer_id', $transfer_id);
        } else {
            $this->db->select('transfer_items.*, product_variants.name as variant')
                ->from('transfer_items')
                ->join('product_variants', 'product_variants.id=transfer_items.option_id', 'left')
                ->group_by('transfer_items.id')
                ->where('transfer_id', $transfer_id);
        }
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
    }

    public function getWarehouseProduct($warehouse_id, $product_id, $variant_id)
    {
        if ($variant_id) {
            $data = $this->getProductWarehouseOptionQty($variant_id, $warehouse_id);
            return $data;
        } else {
            $data = $this->getWarehouseProductQuantity($warehouse_id, $product_id);
            return $data;
        }
        return FALSE;
    }

    public function getWarehouseProductQuantity($warehouse_id, $product_id)
    {
        $q = $this->db->get_where('warehouses_products', array('warehouse_id' => $warehouse_id, 'product_id' => $product_id), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }
        return FALSE;
    }

    public function resetTransferActions($id)
    {
        $otransfer = $this->transfers_model->getTransferByID($id);
        $oitems = $this->transfers_model->getAllTransferItems($id, $otransfer->status);
        $ostatus = $otransfer->status;
        if ($ostatus == 'sent' ||$ostatus == 'completed') {
            // $this->db->update('purchase_items', array('warehouse_id' => $otransfer->from_warehouse_id, 'transfer_id' => NULL), array('transfer_id' => $otransfer->id));
            foreach ($oitems as $item) {
                $option_id = (isset($item->option_id) && ! empty($item->option_id)) ? $item->option_id : NULL;
                $clause = array('purchase_id' => NULL, 'transfer_id' => NULL, 'product_id' => $item->product_id, 'warehouse_id' => $otransfer->from_warehouse_id, 'option_id' => $option_id);
                $pi = $this->site->getPurchasedItem(array('id' => $item->id));
                if ($ppi = $this->site->getPurchasedItem($clause)) {
                    $quantity_balance = $ppi->quantity_balance + $item->quantity;
                    $this->db->update('purchase_items', array('quantity_balance' => $quantity_balance), $clause);
                } else {
                    $clause['quantity'] = $item->quantity;
                    $clause['item_tax'] = 0;
                    $clause['quantity_balance'] = $item->quantity;
                    $this->db->insert('purchase_items', $clause);
                }
            }
        }
        return $ostatus;
    }

    public function deleteTransfer($id)
    {
        $ostatus = $this->resetTransferActions($id);
        $oitems = $this->transfers_model->getAllTransferItems($id, $ostatus);
        $tbl = $ostatus == 'completed' ? 'purchase_items' : 'transfer_items';
        if ($this->db->delete('transfers', array('id' => $id)) && $this->db->delete($tbl, array('transfer_id' => $id))) {
            foreach ($oitems as $item) {
                $this->site->syncQuantity(NULL, NULL, NULL, $item->product_id);
            }
            return true;
        }
        return FALSE;
    }

    public function getProductOptions($product_id, $warehouse_id, $zero_check = TRUE)
    {
        $this->db->select('product_variants.id as id, product_variants.name as name, product_variants.cost as cost, product_variants.quantity as total_quantity, warehouses_products_variants.quantity as quantity')
            ->join('warehouses_products_variants', 'warehouses_products_variants.option_id=product_variants.id', 'left')
            ->where('product_variants.product_id', $product_id)
            ->where('warehouses_products_variants.warehouse_id', $warehouse_id)
            ->group_by('product_variants.id');
        if ($zero_check) {
            $this->db->where('warehouses_products_variants.quantity >', 0);
        }
        $q = $this->db->get('product_variants');
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }

    public function getProductComboItems($pid, $warehouse_id)
    {
        $this->db->select('products.id as id, combo_items.item_code as code, combo_items.quantity as qty, products.name as name, warehouses_products.quantity as quantity')
            ->join('products', 'products.code=combo_items.item_code', 'left')
            ->join('warehouses_products', 'warehouses_products.product_id=products.id', 'left')
            ->where('warehouses_products.warehouse_id', $warehouse_id)
            ->group_by('combo_items.id');
        $q = $this->db->get_where('combo_items', array('combo_items.product_id' => $pid));
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }

            return $data;
        }
        return FALSE;
    }

    public function getProductVariantByName($name, $product_id)
    {
        $q = $this->db->get_where('product_variants', array('name' => $name, 'product_id' => $product_id), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }
        return FALSE;
    }

    public function getPurchasedItems($product_id, $warehouse_id, $option_id = NULL) {
        $orderby = ($this->Settings->accounting_method == 1) ? 'asc' : 'desc';
        $this->db->select('id, quantity, quantity_balance, net_unit_cost, unit_cost, item_tax');
        $this->db->where('product_id', $product_id)->where('warehouse_id', $warehouse_id)->where('quantity_balance !=', 0);
        if ($option_id) {
            $this->db->where('option_id', $option_id);
        }
        $this->db->group_by('id');
        $this->db->order_by('date', $orderby);
        $this->db->order_by('purchase_id', $orderby);
        $q = $this->db->get('purchase_items');
        if ($q->num_rows() > 0) {
            foreach (($q->result()) as $row) {
                $data[] = $row;
            }
            return $data;
        }
        return FALSE;
    }

    public function syncTransderdItem($product_id, $warehouse_id, $quantity, $option_id = NULL)
    {
        if ($pis = $this->getPurchasedItems($product_id, $warehouse_id, $option_id)) {
            $balance_qty = $quantity;
            foreach ($pis as $pi) {
                if ($balance_qty <= $quantity && $quantity > 0) {
                    if ($pi->quantity_balance >= $quantity) {
                        $balance_qty = $pi->quantity_balance - $quantity;
                        $this->db->update('purchase_items', array('quantity_balance' => $balance_qty), array('id' => $pi->id));
                        $quantity = 0;
                    } elseif ($quantity > 0) {
                        $quantity = $quantity - $pi->quantity_balance;
                        $balance_qty = $quantity;
                        $this->db->update('purchase_items', array('quantity_balance' => 0), array('id' => $pi->id));
                    }
                }
                if ($quantity == 0) { break; }
            }
        } else {
            $clause = array('purchase_id' => NULL, 'transfer_id' => NULL, 'product_id' => $product_id, 'warehouse_id' => $warehouse_id, 'option_id' => $option_id);
            if ($pi = $this->site->getPurchasedItem($clause)) {
                $quantity_balance = $pi->quantity_balance - $quantity;
                $this->db->update('purchase_items', array('quantity_balance' => $quantity_balance), $clause);
            } else {
                $clause['quantity'] = 0;
                $clause['item_tax'] = 0;
                $clause['quantity_balance'] = (0 - $quantity);
                $this->db->insert('purchase_items', $clause);
            }
        }
        $this->site->syncQuantity(NULL, NULL, NULL, $product_id);
    }
	
	public function getStatementByDate($section = NULL,$from_date= NULL,$to_date = NULL,$biller_id = NULL){
		if($biller_id != NULL){
			$where_biller = " AND erp_gl_trans.biller_id = $biller_id "; 
		}
		$query = $this->db->query("SELECT
			erp_gl_trans.account_code,
			erp_gl_trans.sectionid,
			erp_gl_charts.accountname,
			erp_gl_charts.parent_acc,
			sum(erp_gl_trans.amount) AS amount
		FROM
			erp_gl_trans
		INNER JOIN erp_gl_charts ON erp_gl_charts.accountcode = erp_gl_trans.account_code
		WHERE
			erp_gl_trans.tran_date BETWEEN '$from_date'
			AND '$to_date'
			AND	erp_gl_trans.sectionid IN ($section)
			$where_biller
		GROUP BY
			erp_gl_trans.account_code;
		");
		return $query;
	}
	
	public function addJournals($data = array())
    {
        if ($this->db->insert_batch('gl_trans', $data)) {
            return true;
        }
        return false;
    }
	public function addCharts($data = array())
    {
        if ($this->db->insert_batch('gl_charts', $data)) {
            return true;
        }
        return false;
    }
	public function getSectionIdByCode($code)
    {

        $q = $this->db->get_where('gl_charts', array('accountcode' => $code), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }

        return FALSE;
    }
	
	public function getAccountCode($accountcode){
		$this->db->select('accountcode');
		$q = $this->db->get_where('gl_charts', array('accountcode' => $accountcode), 1);
        if ($q->num_rows() > 0) {
            return $q->row();
        }
	}
	public function getConditionTax(){
		$this->db->where('id','1');
		$q=$this->db->get('condition_tax');
		return $q->result();
	}
	public function getConditionTaxById($id){
		$this->db->where('id',$id);
		$q=$this->db->get('condition_tax');
		return $q->row();
	}
	public function update_exchange_tax_rate($id,$data){
		$this->db->where('id',$id);
		$update=$this->db->update('condition_tax',$data);
		if($update){
			return true;
		}
	} 
	
	public function getKHM(){
		$q = $this->db->get_where('currencies', array('code'=> 'KHM'), 1);
		if($q->num_rows() > 0){
			$q = $q->row();
            return $q->rate;
		}
	}
	
	public function addConditionTax($data){
		if ($this->db->insert('condition_tax', $data)) {
            return true;
        }
        return false;
	}
	
	public function deleteConditionTax($id){
		$q = $this->db->delete('condition_tax', array('id' => $id));
		if($q){
			return true;
		} else{
			return false;
		}
	}
	
	public function getCustomersDepositByCustomerID($customer_id){
		$q = $this->db
    		->select("deposits.id as dep_id, companies.id AS id , date,companies.name, companies.deposit_amount AS amount, paid_by, CONCAT(erp_users.first_name, ' ', erp_users.last_name) as created_by", false)
    		->from("deposits")
    		->join('users', 'users.id=deposits.created_by', 'inner')
    		->join('companies', 'deposits.company_id = companies.id', 'inner')
    		->where('deposits.amount <>', 0)
			->where('companies.id', $customer_id)
			->get();
		if($q->num_rows() > 0){
			return $q->row();
		}
		return false;
	}
	public function ar_by_customer($start_date=null, $end_date=null, $customer=null, $balance=null, $condition=null, $sale_id=null){
		$w = '';
		if($start_date){
			$w .= " AND (erp_sales.date) >= '".$start_date."'";
		}
		
		if($end_date){
			$w .= " AND (erp_sales.date) <= '".$end_date."' ";
		}
		
		if($customer){
			$w .= " AND erp_sales.customer_id = '".$customer."' ";
		}
		
		if(!$balance){
			$balance = "all";
		}
		
		if($condition=='customer'){
			$q = $this->db
			->select("sales.customer_id,
						sales.customer,
						'".$start_date."' AS start_date,
						'".$end_date."' AS end_date,
						'".$balance."' AS balance ", false)
			->from("sales")
			->where("1 = 1 ".$w."")
			->group_by("customer_id")
			->order_by("customer", "asc")
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
		}elseif($condition=='detail'){
			//echo $start_date."<br>".$end_date."<br>".$customer."<br>".$balance; exit();
			$q = $this->db
			->select("sales.customer_id,
						sales.id,
						sales.customer,
						sales.reference_no,
						sales.date,
						sales.grand_total,
						0 as order_discount,
						erp_returns.amount as amount_return,
						erp_deposits.amount as amount_deposit
					", false)
			->from("sales")
			->join("payments erp_returns","erp_returns.sale_id = sales.id AND erp_returns.return_id<>''","left")
			->join("payments erp_deposits","erp_deposits.sale_id = sales.id AND erp_deposits.deposit_id<>''","left")
			->where("1 = 1 ".$w."")
			->group_by("sales.reference_no")
			->order_by("sales.reference_no", "desc")
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
			
		}elseif($condition=='payment'){
			
			$q = $this->db
			->select("payments.amount,
					  payments.reference_no,
					  payments.date
					", false)
			->from("payments")
			->where("payments.sale_id<>", "")
			->where("payments.sale_id=", $sale_id)
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
			
		}
	}
	public function ap_by_supplier($start_date=null, $end_date=null, $supplier=null, $balance=null, $condition=null, $purchase_id=null){
		
		$w = '';
		if($start_date){
			$w .= " AND (erp_purchases.date) >= '".$start_date."'";
		}
		
		if($end_date){
			$w .= " AND (erp_purchases.date) <= '".$end_date."' ";
		}
		
		if($supplier){
			$w .= " AND erp_purchases.supplier_id = '".$supplier."' ";
		}
		
		if(!$balance){
			$balance = "all";
		}
		
		if($condition=='supplier'){
			$q = $this->db
			->select("purchases.supplier_id,
						purchases.supplier,
						'".$start_date."' AS start_date,
						'".$end_date."' AS end_date,
						'".$balance."' AS balance ", false)
			->from("purchases")
			->where("1 = 1 ".$w."")
			->group_by("supplier_id")
			->order_by("supplier", "asc")
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
		}elseif($condition=='detail'){
			//echo $start_date."<br>".$end_date."<br>".$supplier."<br>".$balance; exit();
			$q = $this->db
			->select("purchases.supplier_id,
						purchases.id,
						purchases.supplier,
						purchases.reference_no,
						purchases.date,
						purchases.grand_total,
						0 as order_discount,
						erp_returns.amount as amount_return,
						erp_deposits.amount as amount_deposit
					", false)
			->from("purchases")
			->join("payments erp_returns","erp_returns.purchase_id = purchases.id AND erp_returns.purchase_return_id<>''","left")
			->join("payments erp_deposits","erp_deposits.purchase_id = purchases.id AND erp_deposits.purchase_deposit_id<>''","left")
			->where("1 = 1 ".$w."")
			->group_by("purchases.reference_no")
			->order_by("purchases.reference_no", "desc")
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
			
		}elseif($condition=='payment'){
			
			$q = $this->db
			->select("payments.amount,
					  payments.reference_no,
					  payments.date
					", false)
			->from("payments")
			->where("payments.purchase_id<>", "")
			->where("payments.purchase_id=", $purchase_id)
			->get();
			if($q->num_rows() > 0){
				return $q->result();
			}
			return false;
			
		}
		
	}
}
