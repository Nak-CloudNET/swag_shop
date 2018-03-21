<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Suppliers extends MY_Controller
{

    function __construct()
    {
        parent::__construct();

        if (!$this->loggedIn) {
            $this->session->set_userdata('requested_page', $this->uri->uri_string());
            redirect('login');
        }
        if ($this->Customer || $this->Supplier) {
            $this->session->set_flashdata('warning', lang('access_denied'));
            redirect($_SERVER["HTTP_REFERER"]);
        }
        $this->lang->load('suppliers', $this->Settings->language);
        $this->load->library('form_validation');
        $this->load->model('companies_model');
    }

    function index($action = NULL)
    {
        $this->erp->checkPermissions();

        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['action'] = $action;
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('suppliers')));
        $meta = array('page_title' => lang('suppliers'), 'bc' => $bc);
        $this->page_construct('suppliers/index', $meta, $this->data);
    }

    function getSuppliers()
    {
        $this->erp->checkPermissions('index');

        $this->load->library('datatables');
		$code = 0;
		if($setting->show_company_code == 1){
			$code = 1;
		}
		
        $this->datatables
            ->select("id, (CASE WHEN ".$code." = 1 THEN code ELSE id END) AS sup, company, name, email, phone, city, country, vat_no, deposit_amount")
            ->from("companies")
            ->where('group_name', 'supplier')
            ->add_column("Actions", "<div class=\"text-center\"><a class=\"tip\" title='" . $this->lang->line("edit_supplier") . "' href='" . site_url('suppliers/edit/$1') . "' data-toggle='modal' data-target='#myModal'><i class=\"fa fa-edit\"></i></a> <a class=\"tip\" title='" . lang("list_deposits") . "' href='" . site_url('suppliers/deposits/$1') . "'><i class=\"fa fa-money\"></i></a> <a class=\"tip\" title='" . lang("add_deposit") . "' href='" . site_url('suppliers/add_deposit/$1') . "' data-toggle='modal' data-target='#myModal'><i class=\"fa fa-plus\"></i></a> <a class=\"tip\" title='" . $this->lang->line("list_users") . "' href='" . site_url('suppliers/users/$1') . "' data-toggle='modal' data-target='#myModal'><i class=\"fa fa-users\"></i></a> <a class=\"tip\" title='" . $this->lang->line("add_user") . "' href='" . site_url('suppliers/add_user/$1') . "' data-toggle='modal' data-target='#myModal'><i class=\"fa fa-plus-circle\"></i></a> <a href='#' class='tip po' title='<b>" . $this->lang->line("delete_supplier") . "</b>' data-content=\"<p>" . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' href='" . site_url('suppliers/delete/$1') . "'>" . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i></a></div>", "id");
        //->unset_column('id');
        echo $this->datatables->generate();
    }

    function view($id = NULL)
    {
        $this->erp->checkPermissions('index', true);
        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['supplier'] = $this->companies_model->getCompanyByID($id);
        $this->load->view($this->theme.'suppliers/view',$this->data);
    }

    function add()
    {
        $this->erp->checkPermissions(false, true);

        $this->form_validation->set_rules('email', $this->lang->line("email_address"), 'is_unique[companies.email]');

        if ($this->form_validation->run('companies/add') == true) {

            $data = array('name' => $this->input->post('name'),
                'email' => $this->input->post('email'),
                'group_id' => '4',
                'group_name' => 'supplier',
                'company' => $this->input->post('company'),
                'address' => $this->input->post('address'),
                'vat_no' => $this->input->post('vat_no'),
                'city' => $this->input->post('city'),
                'state' => $this->input->post('state'),
                'postal_code' => $this->input->post('postal_code'),
                'country' => $this->input->post('country'),
                'phone' => $this->input->post('phone'),
                'cf1' => $this->input->post('cf1'),
                'cf2' => $this->input->post('cf2'),
                'cf3' => $this->input->post('cf3'),
                'cf4' => $this->input->post('cf4'),
                'cf5' => $this->input->post('cf5'),
                'cf6' => $this->input->post('cf6'),
            );
        } elseif ($this->input->post('add_supplier')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect('suppliers');
        }

        if ($this->form_validation->run() == true && $sid = $this->companies_model->addCompany($data)) {
            $this->session->set_flashdata('message', $this->lang->line("supplier_added"));
           // $ref = isset($_SERVER["HTTP_REFERER"]) ? explode('?', $_SERVER["HTTP_REFERER"]) : NULL;
           // redirect($ref[0] . '?supplier=' . $sid);
		   redirect('suppliers');
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'suppliers/add', $this->data);
        }
    }

    function edit($id = NULL)
    {
        $this->erp->checkPermissions(false, true);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }

        $company_details = $this->companies_model->getCompanyByID($id);
        if ($this->input->post('email') != $company_details->email) {
            $this->form_validation->set_rules('code', lang("email_address"), 'is_unique[companies.email]');
        }

        if ($this->form_validation->run('companies/add') == true) {
            $data = array('name' => $this->input->post('name'),
                'email' => $this->input->post('email'),
                'group_id' => '4',
                'group_name' => 'supplier',
                'company' => $this->input->post('company'),
				'code' => $this->input->post('code'),
                'address' => $this->input->post('address'),
                'vat_no' => $this->input->post('vat_no'),
                'city' => $this->input->post('city'),
                'state' => $this->input->post('state'),
                'postal_code' => $this->input->post('postal_code'),
                'country' => $this->input->post('country'),
                'phone' => $this->input->post('phone'),
                'cf1' => $this->input->post('cf1'),
                'cf2' => $this->input->post('cf2'),
                'cf3' => $this->input->post('cf3'),
                'cf4' => $this->input->post('cf4'),
                'cf5' => $this->input->post('cf5'),
                'cf6' => $this->input->post('cf6'),
            );
        } elseif ($this->input->post('edit_supplier')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER["HTTP_REFERER"]);
        }

        if ($this->form_validation->run() == true && $this->companies_model->updateCompany($id, $data)) {
            $this->session->set_flashdata('message', $this->lang->line("supplier_updated"));
            redirect($_SERVER["HTTP_REFERER"]);
        } else {
            $this->data['supplier'] = $company_details;
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'suppliers/edit', $this->data);
        }
    }

    function users($company_id = NULL)
    {
        $this->erp->checkPermissions(false, true);

        if ($this->input->get('id')) {
            $company_id = $this->input->get('id');
        }


        $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
        $this->data['modal_js'] = $this->site->modal_js();
        $this->data['company'] = $this->companies_model->getCompanyByID($company_id);
        $this->data['users'] = $this->companies_model->getCompanyUsers($company_id);
        $this->load->view($this->theme . 'suppliers/users', $this->data);

    }

    function add_user($company_id = NULL)
    {
        $this->erp->checkPermissions(false, true);

        if ($this->input->get('id')) {
            $company_id = $this->input->get('id');
        }
        $company = $this->companies_model->getCompanyByID($company_id);

        $this->form_validation->set_rules('email', $this->lang->line("email_address"), 'is_unique[users.email]');
        $this->form_validation->set_rules('password', $this->lang->line('password'), 'required|min_length[8]|max_length[20]|matches[password_confirm]');
        $this->form_validation->set_rules('password_confirm', $this->lang->line('confirm_password'), 'required');

        if ($this->form_validation->run('companies/add_user') == true) {
            $active = $this->input->post('status');
            $notify = $this->input->post('notify');
            list($username, $domain) = explode("@", $this->input->post('email'));
            $email = strtolower($this->input->post('email'));
            $password = $this->input->post('password');
            $additional_data = array(
                'first_name' => $this->input->post('first_name'),
                'last_name' => $this->input->post('last_name'),
                'phone' => $this->input->post('phone'),
                'gender' => $this->input->post('gender'),
                'company_id' => $company->id,
                'company' => $company->company,
                'group_id' => 3
            );
            $this->load->library('ion_auth');
        } elseif ($this->input->post('add_user')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect('suppliers');
        }

        if ($this->form_validation->run() == true && $this->ion_auth->register($username, $password, $email, $additional_data, $active, $notify)) {
            $this->session->set_flashdata('message', $this->lang->line("user_added"));
            redirect("suppliers");
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['company'] = $company;
            $this->load->view($this->theme . 'suppliers/add_user', $this->data);
        }
    }

    function import_csv()
    {
        $this->erp->checkPermissions();
        $this->load->helper('security');
        $this->form_validation->set_rules('csv_file', $this->lang->line("upload_file"), 'xss_clean');

        if ($this->form_validation->run() == true) {

            if (DEMO) {
                $this->session->set_flashdata('warning', $this->lang->line("disabled_in_demo"));
                redirect($_SERVER["HTTP_REFERER"]);
            }

            if (isset($_FILES["csv_file"])) /* if($_FILES['userfile']['size'] > 0) */ {

                $this->load->library('upload');

                $config['upload_path'] = 'assets/uploads/csv/';
                $config['allowed_types'] = 'csv';
                $config['max_size'] = '2000';
                $config['overwrite'] = TRUE;

                $this->upload->initialize($config);

                if (!$this->upload->do_upload('csv_file')) {

                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("suppliers");
                }

                $csv = $this->upload->file_name;

                $arrResult = array();
                $handle = fopen("assets/uploads/csv/" . $csv, "r");
                if ($handle) {
                    while (($row = fgetcsv($handle, 5001, ",")) !== FALSE) {
                        $arrResult[] = $row;
                    }
                    fclose($handle);
                }
                $titles = array_shift($arrResult);

                $keys = array('code', 'company', 'name', 'email', 'phone', 'address', 'city', 'state', 'postal_code', 'country', 'vat_no', 'cf1', 'cf2', 'cf3', 'cf4', 'cf5', 'cf6');

                $final = array();

                foreach ($arrResult as $key => $value) {
                    $final[] = array_combine($keys, $value);
                }
                $rw = 2;
                foreach ($final as $csv) {
                    if ($this->companies_model->getCompanyByEmail($csv['email'])) {
                        $this->session->set_flashdata('error', $this->lang->line("check_supplier_email") . " (" . $csv['email'] . "). " . $this->lang->line("supplier_already_exist") . " (" . $this->lang->line("line_no") . " " . $rw . ")");
                        redirect("suppliers");
                    }
                    $rw++;
                }
                foreach ($final as $record) {
                    $record['group_id'] = 4;
                    $record['group_name'] = 'supplier';
                    $data[] = $record;
                }
                //$this->erp->print_arrays($data);
            }

        } elseif ($this->input->post('import')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect('customers');
        }

        if ($this->form_validation->run() == true && !empty($data)) {
            if ($this->companies_model->addCompanies($data)) {
                $this->session->set_flashdata('message', $this->lang->line("suppliers_added"));
                redirect('suppliers');
            }
        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'suppliers/import', $this->data);
        }
    }

    function delete($id = NULL)
    {
        $this->erp->checkPermissions(NULL, TRUE);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }

        if ($this->companies_model->deleteSupplier($id)) {
            echo $this->lang->line("supplier_deleted");
        } else {
            $this->session->set_flashdata('warning', lang('supplier_x_deleted_have_purchases'));
            die("<script type='text/javascript'>setTimeout(function(){ window.top.location.href = '" . (isset($_SERVER["HTTP_REFERER"]) ? $_SERVER["HTTP_REFERER"] : site_url('welcome')) . "'; }, 0);</script>");
        }
    }

    function suggestions($term = NULL, $limit = NULL)
    {
        // $this->erp->checkPermissions('index');
        if ($this->input->get('term')) {
            $term = $this->input->get('term', TRUE);
        }
        $limit = $this->input->get('limit', TRUE);
        $rows['results'] = $this->companies_model->getSupplierSuggestions($term, $limit);
        echo json_encode($rows);
    }

    function getSupplier($id = NULL)
    {
        // $this->erp->checkPermissions('index');
        $row = $this->companies_model->getCompanyByID($id);
        echo json_encode(array(array('id' => $row->id, 'text' => $row->company)));
    }

    function supplier_actions()
    {
        if (!$this->Owner) {
            $this->session->set_flashdata('warning', lang('access_denied'));
            redirect($_SERVER["HTTP_REFERER"]);
        }

        $this->form_validation->set_rules('form_action', lang("form_action"), 'required');

        if ($this->form_validation->run() == true) {

            if (!empty($_POST['val'])) {
                if ($this->input->post('form_action') == 'delete') {
                    $error = false;
                    foreach ($_POST['val'] as $id) {
                        if (!$this->companies_model->deleteSupplier($id)) {
                            $error = true;
                        }
                    }
                    if ($error) {
                        $this->session->set_flashdata('warning', lang('suppliers_x_deleted_have_purchases'));
                    } else {
                        $this->session->set_flashdata('message', $this->lang->line("suppliers_deleted"));
                    }
                    redirect($_SERVER["HTTP_REFERER"]);
                }

                if ($this->input->post('form_action') == 'export_excel' || $this->input->post('form_action') == 'export_pdf') {

                    $this->load->library('excel');
                    $this->excel->setActiveSheetIndex(0);
                    $this->excel->getActiveSheet()->setTitle(lang('customer'));
                    $this->excel->getActiveSheet()->SetCellValue('A1', lang('no'));
                    $this->excel->getActiveSheet()->SetCellValue('B1', lang('code'));
                    $this->excel->getActiveSheet()->SetCellValue('C1', lang('company'));
                    $this->excel->getActiveSheet()->SetCellValue('D1', lang('name'));
                    $this->excel->getActiveSheet()->SetCellValue('E1', lang('email'));
                    $this->excel->getActiveSheet()->SetCellValue('F1', lang('phone'));
                    $this->excel->getActiveSheet()->SetCellValue('G1', lang('city'));
                    $this->excel->getActiveSheet()->SetCellValue('H1', lang('country'));
                    $this->excel->getActiveSheet()->SetCellValue('I1', lang('vat_no'));

                    $row = 2;
                    foreach ($_POST['val'] as $id) {
                        $customer = $this->site->getCompanyByID($id);
                        $this->excel->getActiveSheet()->SetCellValue('A' . $row, $customer->id);
                        $this->excel->getActiveSheet()->SetCellValue('B' . $row, $customer->code);
                        $this->excel->getActiveSheet()->SetCellValue('C' . $row, $customer->company);
                        $this->excel->getActiveSheet()->SetCellValue('D' . $row, $customer->name);
                        $this->excel->getActiveSheet()->SetCellValue('E' . $row, $customer->email);
                        $this->excel->getActiveSheet()->SetCellValue('F' . $row, $customer->phone);
                        $this->excel->getActiveSheet()->SetCellValue('G' . $row, $customer->city);
                        $this->excel->getActiveSheet()->SetCellValue('H' . $row, $customer->country);
                        $this->excel->getActiveSheet()->SetCellValue('I' . $row, $customer->vat_no);
                        $row++;
                    }

                   
                    $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                    $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                    $filename = 'suppliers_' . date('Y_m_d_H_i_s');
                    if ($this->input->post('form_action') == 'export_pdf') {
                        $styleArray = array('borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN)));
                        $this->excel->getDefaultStyle()->applyFromArray($styleArray);
                        $this->excel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
                        require_once(APPPATH . "third_party" . DIRECTORY_SEPARATOR . "MPDF" . DIRECTORY_SEPARATOR . "mpdf.php");
                        $rendererName = PHPExcel_Settings::PDF_RENDERER_MPDF;
                        $rendererLibrary = 'MPDF';
                        $rendererLibraryPath = APPPATH . 'third_party' . DIRECTORY_SEPARATOR . $rendererLibrary;
                        if (!PHPExcel_Settings::setPdfRenderer($rendererName, $rendererLibraryPath)) {
                            die('Please set the $rendererName: ' . $rendererName . ' and $rendererLibraryPath: ' . $rendererLibraryPath . ' values' .
                                PHP_EOL . ' as appropriate for your directory structure');
                        }

                        header('Content-Type: application/pdf');
                        header('Content-Disposition: attachment;filename="' . $filename . '.pdf"');
                        header('Cache-Control: max-age=0');

                        $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'PDF');
                        return $objWriter->save('php://output');
                    }
                    if ($this->input->post('form_action') == 'export_excel') {
                        header('Content-Type: application/vnd.ms-excel');
                        header('Content-Disposition: attachment;filename="' . $filename . '.xls"');
                        header('Cache-Control: max-age=0');

                        $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'Excel5');
                        return $objWriter->save('php://output');
                    }

                    redirect($_SERVER["HTTP_REFERER"]);
                }
            } else {
                $this->session->set_flashdata('error', $this->lang->line("no_supplier_selected"));
                redirect($_SERVER["HTTP_REFERER"]);
            }
        } else {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER["HTTP_REFERER"]);
        }
    }
	
	function deposits($action = NULL)
    {
    	$this->erp->checkPermissions('index', true, 'accounts');

    	$this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
    	$this->data['action'] = $action;
    	$bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('accounts')));
    	$meta = array('page_title' => lang('supplier_deposit'), 'bc' => $bc);
    	$this->page_construct('suppliers/deposits', $meta, $this->data);
    }
	
	public function getDeposits(){

    	$return_deposit = anchor('suppliers/return_deposit/$1', '<i class="fa fa-reply"></i> ' . lang('return_deposit'), 'data-toggle="modal" data-target="#myModal2"');
    	$deposit_note = anchor('suppliers/deposit_note/$1', '<i class="fa fa-file-text-o"></i> ' . lang('deposit_note'), 'data-toggle="modal" data-target="#myModal2"');
    	$edit_deposit = anchor('suppliers/edit_deposit/$1', '<i class="fa fa-edit"></i> ' . lang('edit_deposit'), 'data-toggle="modal" data-target="#myModal2"');
    	$delete_deposit = "<a href='#' class='po' title='<b>" . lang("delete_deposit") . "</b>' data-content=\"<p>"
    	. lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' href='" . site_url('suppliers/deleteDeposit/$1') . "'>"
    	. lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i> "
    	. lang('delete_deposit') . "</a>";

    	$action = '<div class="text-center"><div class="btn-group text-left">'
    	. '<button type="button" class="btn btn-default btn-xs btn-primary dropdown-toggle" data-toggle="dropdown">'
    	. lang('actions') . ' <span class="caret"></span></button>
    	<ul class="dropdown-menu pull-right" role="menu">
    		<li>' . $deposit_note . '</li>
    		<li>' . $edit_deposit . '</li>
    		<li>' . $return_deposit . '</li>
    		<li>' . $delete_deposit . '</li>
    		<ul>
    		</div></div>';

    		$this->load->library('datatables');
    		$this->datatables
    		->select("deposits.id as dep_id, companies.id AS id , deposits.reference, deposits.date,companies.name, deposits.amount, deposits.paid_by, CONCAT({$this->db->dbprefix('users')}.first_name, ' ', {$this->db->dbprefix('users')}.last_name) as created_by", false)
    		->from("deposits")
			->join('companies', 'companies.id = deposits.company_id', 'left')
    		->join('users', 'users.id=deposits.created_by', 'left')
			->where('companies.group_name', 'supplier')
    		->where('deposits.amount <>', 0)
    		->where('deposits.reference <>', '')
    		->add_column("Actions", $action, "dep_id")
			->unset_column('dep_id');

    		echo $this->datatables->generate();
    }
	
	function add_deposit($id)
    {
        $this->erp->checkPermissions('deposits', true);

        if ($this->Owner || $this->Admin) {
            $this->form_validation->set_rules('date', lang("date"), 'required');
        }
		$this->form_validation->set_rules('date', lang("date"), 'required');
        $this->form_validation->set_rules('amount', lang("amount"), 'required|numeric');
        
        if ($this->form_validation->run() == true) {
			$supplier_id = $this->input->post('supplier_id');
			$company = $this->site->getCompanyByID($supplier_id);
			$reference = $this->site->getReference('sd') ? $this->site->getReference('sd'): $this->input->post('reference_no');

            if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld(trim($this->input->post('date')));
            } else {
                $date = date('Y-m-d H:i:s');
            }
			$reference_no=$this->input->post('po_reference_no');
			$po_paid=$this->input->post('po_paid');
			$amount_dep=$this->input->post('amount');
			$po=array(
				'paid' => $po_paid+$amount_dep,
			);
            $data = array(
                'reference' => $reference,
                'po_reference_no' => $this->input->post('po_reference_no'),
                'date' => $date,
                'amount' => $this->input->post('amount'),
                'paid_by' => $this->input->post('paid_by'),
                'note' => $this->input->post('note') ? $this->input->post('note') : $company->name,
                'company_id' => $company->id,
                'created_by' => $this->session->userdata('user_id'),
				'biller_id' => $this->input->post('biller')
            );
			$payment = array(
				'date' => $date,
				'reference_no' => $this->site->getReference('pp'),
				'amount' => $this->input->post('amount'),
				'paid_by' => $this->input->post('paid_by'),
				'cheque_no' => $this->input->post('cheque_no'),
				'cc_no' => $this->input->post('paid_by') == 'gift_card' ? $this->input->post('gift_card_no') : $this->input->post('pcc_no'),
				'cc_holder' => $this->input->post('pcc_holder'),
				'cc_month' => $this->input->post('pcc_month'),
				'cc_year' => $this->input->post('pcc_year'),
				'cc_type' => $this->input->post('pcc_type'),
				'note' => $this->input->post('note') ? $this->input->post('note') : $company->name,
				'created_by' => $company->id,
				'type' => 'received',
				'biller_id'	=> $this->input->post('biller')
			);
            $cdata = array(
                'deposit_amount' => ($company->deposit_amount+$this->input->post('amount'))
            );
        } elseif ($this->input->post('add_deposit')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER['HTTP_REFERER']);
        }

        if ($this->form_validation->run() == true && $this->companies_model->addSupplierDeposit($data, $cdata, $payment,$po,$reference_no)) {
            $this->session->set_flashdata('message', lang("deposit_added"));
            redirect($_SERVER['HTTP_REFERER']);
        } else {
			$this->data['po_reference'] = $this->companies_model->getPOReference();
			$this->data['reference'] = $this->site->getReference('sd');
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			$company = $this->companies_model->getCompanyByID($id);
			$this->data['billers'] = $this->site->getAllCompanies('biller');
			$this->data['company'] = $company;
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['suppliers'] = $this->site->getSuppliers();
            $this->load->view($this->theme . 'suppliers/add_deposit', $this->data);
        }
    }
	
	function edit_deposit($id = NULL)
    {
        $this->erp->checkPermissions('deposits', true);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }
        $deposit = $this->companies_model->getDepositByID($id);
        $company = $this->companies_model->getCompanyByID($deposit->company_id);
		$payment = $this->companies_model->getPaymentBySupplierDeposit($id);
		$payment_reference = $payment->reference_no;

        if ($this->Owner || $this->Admin) {
            $this->form_validation->set_rules('date', lang("date"), 'required');
        }
        $this->form_validation->set_rules('amount', lang("amount"), 'required|numeric');
        
        if ($this->form_validation->run() == true) {

            if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld(trim($this->input->post('date')));
            } else {
                $date = $deposit->date;
            }
            $data = array(
                'date' => $date,
                'reference' => $this->input->post('reference_no'),
                'amount' => $this->input->post('amount'),
                'paid_by' => $this->input->post('paid_by'),
                'note' => $this->input->post('note'),
                'company_id' => $deposit->company_id,
                'updated_by' => $this->session->userdata('user_id'),
                'updated_at' => $date = date('Y-m-d H:i:s'),
				'biller_id' => $this->input->post('biller')
            );
			
			$payment = array(
				'date' => $date,
				'purchase_deposit_id' => $id,
				//'reference_no' => $this->site->getReference('pp'),
				'reference_no' => $payment_reference,
				'amount' => $this->input->post('amount'),
				'paid_by' => $this->input->post('paid_by'),
				'cheque_no' => $this->input->post('cheque_no'),
				'cc_no' => $this->input->post('paid_by') == 'gift_card' ? $this->input->post('gift_card_no') : $this->input->post('pcc_no'),
				'cc_holder' => $this->input->post('pcc_holder'),
				'cc_month' => $this->input->post('pcc_month'),
				'cc_year' => $this->input->post('pcc_year'),
				'cc_type' => $this->input->post('pcc_type'),
				'note' => $this->input->post('note') ? $this->input->post('note') : $company->name,
				'type' => 'received',
				'biller_id'	=> $this->input->post('biller')
			);

            $cdata = array(
                'deposit_amount' => (($company->deposit_amount-$deposit->amount)+$this->input->post('amount'))
            );

        } elseif ($this->input->post('edit_deposit')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect("suppliers/deposits");
        }

        if ($this->form_validation->run() == true && $this->companies_model->updateSupplierDeposit($id, $data, $cdata, $payment)) {
            $this->session->set_flashdata('message', lang("deposit_updated"));
            redirect("suppliers/deposits");
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			$this->data['billers'] = $this->site->getAllCompanies('biller');
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['supplier'] = $company;
            $this->data['deposit'] = $deposit;
            $this->load->view($this->theme . 'suppliers/edit_deposit', $this->data);
        }
    }
	
	public function deposit_note($id = null)
    {
        $this->erp->checkPermissions('deposits', true);
        $deposit = $this->companies_model->getDepositByID($id);
        $this->data['customer'] = $this->companies_model->getCompanyByID($deposit->company_id);
        $this->data['deposit'] = $deposit;
        $this->data['page_title'] = $this->lang->line("deposit_note");
        $this->load->view($this->theme . 'suppliers/deposit_note', $this->data);
    }
	
	public function return_deposit($id){
		$this->erp->checkPermissions('deposits', true);
		if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }
        $deposit = $this->companies_model->getDepositByID($id);
        $company = $this->companies_model->getCompanyByID($deposit->company_id);
		if ($this->Owner || $this->Admin) {
            $this->form_validation->set_rules('date', lang("date"), 'required');
        }
        $this->form_validation->set_rules('amount', lang("amount"), 'required|numeric');
		if($this->form_validation->run() == true){
			if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld(trim($this->input->post('date')));
            } else {
                $date = $deposit->date;
            }
            $data = array(
                'amount' => ($deposit->amount - $this->input->post('amount')),
                'note' => $this->input->post('note'),
                'company_id' => $deposit->company_id,
                'updated_by' => $this->session->userdata('user_id'),
                'updated_at' => $date = date('Y-m-d H:i:s'),
				'biller_id' => $this->input->post('biller')
            );
			
			$payment = array(
				'date' => $date,
				'deposit_id' => $id,
				'reference_no' => $this->site->getReference('pp'),
				'amount' => $this->input->post('amount'),
				'paid_by' => 'cash',
				'note' => $this->input->post('note') ? $this->input->post('note') : $company->name,
				'type' => 'received',
				'biller_id'	=> $this->input->post('biller')
			);

            $cdata = array(
                'deposit_amount' => (($deposit->amount - $this->input->post('amount')))
            );
		} elseif ($this->input->post('return_deposit')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER['HTTP_REFERER']);
        }
		if ($this->form_validation->run() == true && $this->companies_model->ReturnDeposit($id, $data, $cdata, $payment)) {
            $this->session->set_flashdata('message', lang("deposit_returned"));
            redirect($_SERVER['HTTP_REFERER']);
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			$this->data['billers'] = $this->site->getAllCompanies('biller');
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['company'] = $company;
            $this->data['deposit'] = $deposit;
            $this->load->view($this->theme . 'suppliers/return_deposit', $this->data);
        }
	}
	
	function deleteDeposit($id = NULL)
    {
        $this->erp->checkPermissions(NULL, TRUE);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }

        if ($this->companies_model->deleteSupplierDeposit($id)) {
            if($this->input->is_ajax_request()) {
                echo lang("purchase_deposit_deleted"); die();
            }
            $this->session->set_flashdata('message', lang('purchase_deposit_deleted'));
            redirect($_SERVER['HTTP_REFERER']);
        }
    }
	function getPORef()
    {
		$data=array();
        $ref = $this->input->get('ref', TRUE);
		$data = $this->companies_model->getPORef($ref);
		echo json_encode($data);
    }

}
