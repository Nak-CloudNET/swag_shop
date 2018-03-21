<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Sale_order_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
		$this->load->model('quotes_model');
    }

    public function addSaleOrder($data, $products){
		
		if(isset($data) AND !empty($data) and isset($products) AND !empty($products)){
			$this->db->insert('sale_order',$data);
			$sale_order_id = $this->db->insert_id();
			
			if($sale_order_id>0){
				$status = false;
				foreach($products as $product){
					$prod = array(
						'sale_order_id' => $sale_order_id,
						'product_id' => $product['product_id'],
						'product_code' => $product['product_code'],
						'product_name' => $product['product_name'],
						'product_type' => $product['product_type'],
						'option_id' => $product['option_id'],
						'net_unit_price' => $product['net_unit_price'],
						'unit_price' => $product['unit_price'],
						'quantity' => $product['quantity'],
						'warehouse_id' => $product['warehouse_id'],
						'item_tax' => $product['item_tax'],
						'tax_rate_id' => $product['tax_rate_id'],
						'tax' => $product['tax'],
						'discount' => $product['discount'],
						'item_discount' => $product['item_discount'],
						'subtotal' => $product['subtotal'],
						'serial_no' => $product['serial_no'],
						'real_unit_price' => $product['real_unit_price'],
						'product_noted' => $product['product_noted']
						
					);
					
					if($this->db->insert('sale_order_items',$prod)){
						$insert_id = $this->db->insert_id();
					}
				}
				if($insert_id == true){
					return $sale_order_id;
				}
				
			}
			return false;
		
		}
	}
	
	public function add_deposit($deposit){
		$this->db->insert('deposits',$deposit); 
		if($this->db->affected_rows()>0){
			return true;
		}
		return false; 
	}
	
    public function getInvoiceByID($id)
    {
        $this->db->select("sale_order.id, sale_order.date, sale_order.reference_no, sale_order.biller, companies.name AS customer, users.username AS saleman,delivery.name as delivery_man,grand_total, paid,(grand_total-paid) as balance")
				->from('sale_order')
				->join('companies', 'companies.id = sale_order.customer_id', 'left')
				->join('users', 'users.id = sale_order.saleman_by', 'left')
				->join('companies as delivery', 'delivery.id = sale_order.delivery_by', 'left')
				->join('deliveries', 'deliveries.sale_id = sale_order.id', 'left')
				
                ->where('sale_order.opening_ar!=','2')
				->where("sale_order.id",$id)
				->group_by('sale_order.id');
				$q = $this->db->get();
         if ($q) {
           return $q->row();
        }
        return FALSE;
    }
	 public function getInvoice()
    {
		/*$this->db->select("sales.*, companies.name AS customer, users.username,,delivery.name as delivery_man,(grand_total-paid) as balance")
				->from('sales')
				->join('users', 'users.id = sales.saleman_by', 'left')
				->join('companies', 'companies.id = sales.customer_id', 'left')
				->join('deliveries', 'deliveries.sale_id = sales.id', 'left')
				->join('companies as delivery', 'delivery.id = sales.delivery_by', 'left')
                //->where('sales.opening_ar!=','2')
				->group_by('sales.id');
				//->where(array('sales.id' => $id));
        $q = $this->db->get();
        if ($q->num_rows() > 0) {
            return $q->result();
        }
        return FALSE;
    }*/
		$this->db->select("sale_order.id, sale_order.date, sale_order.reference_no, sale_order.biller, companies.name AS customer, users.username AS saleman,delivery.name as delivery_man,grand_total, paid,(grand_total-paid) as balance")
				 ->from('sale_order')
				 ->join('companies', 'companies.id = sale_order.customer_id', 'left')
				 ->join('users', 'users.id = sale_order.saleman_by', 'left')
				 ->join('companies as delivery', 'delivery.id = sale_order.delivery_by', 'left')
				 ->join('deliveries', 'deliveries.sale_id = sale_order.id', 'left')
				
                //->where('sale_order.opening_ar!=','2')
				//->where("sale_order.id",$id)
				 ->group_by('sale_order.id');
		$q = $this->db->get();
		if ($q->num_rows() > 0) {
			return $q->result();
		}
		return FALSE;
	}
	
	public function deleteSaleOrderByID($sale_order_id = null){
		$this->db->delete('erp_sale_order', array('id' => $sale_order_id));
		if($this->db->affected_rows()>0){
			$this->db->delete('erp_sale_order_items', array('sale_order_id' => $sale_order_id));
			if($this->db->affected_rows()>0){
				return true;
			}
		}
		return false;
	}
	
	public function getSaleOrder($sale_order_id=null){
		$q = $this->db->get_where('erp_sale_order',array('id'=>$sale_order_id));
		if($q->num_rows()>0){
			return $q->row();
		}
		return null;
	}
	public function getCustomersByArea($area){		
		$this->db->select('id as id, CONCAT(name ," (",company, ")" ) as text');
		$q = $this->db->get_where('companies', array('group_name' => 'customer','group_areas_id' => $area));
        if($q->num_rows() > 0) {
			return $q->result();
		}
		return false;
	}
	public function getSaleOrderItems($sale_order_id=null){
		$q = $this->db->get_where('erp_sale_order_items',array('sale_order_id'=>$sale_order_id));
		if($q->num_rows()>0){
			foreach($q->result() as $row){
				$data[] = $row;
			}
			return $data;
		}
		return null;
	}
}
