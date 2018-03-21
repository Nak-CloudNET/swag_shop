<?php defined('BASEPATH') OR exit('No direct script access allowed');

class Products extends MY_Controller
{
    function __construct()
    {
        parent::__construct();
        if (!$this->loggedIn) {
            $this->session->set_userdata('requested_page', $this->uri->uri_string());
            redirect('login');
        }
		$this->lang->load('settings', $this->Settings->language);
        $this->load->library('form_validation');
        $this->load->model('settings_model');
		
        $this->lang->load('products', $this->Settings->language);
        $this->load->library('form_validation');
        $this->load->model('products_model');
        $this->digital_upload_path = 'files/';
        $this->upload_path = 'assets/uploads/';
        $this->thumbs_path = 'assets/uploads/thumbs/';
        $this->image_types = 'gif|jpg|jpeg|png|tif';
        $this->digital_file_types = 'zip|psd|ai|rar|pdf|doc|docx|xls|xlsx|ppt|pptx|gif|jpg|jpeg|png|tif|txt';
        $this->allowed_file_size = '1024';
        $this->popup_attributes = array('width' => '900', 'height' => '600', 'window_name' => 'erp_popup', 'menubar' => 'yes', 'scrollbars' => 'yes', 'status' => 'no', 'resizable' => 'yes', 'screenx' => '0', 'screeny' => '0');
		
		if(!$this->Owner && !$this->Admin) {
            $gp = $this->site->checkPermissions();
            $this->permission = $gp[0];
            $this->permission[] = $gp[0];
        } else {
            $this->permission[] = NULL;
        }
		$this->default_biller_id = $this->site->default_biller_id();
    }

    function index($warehouse_id = NULL)
    {
        $this->erp->checkPermissions();
        
		$this->data['products'] = $this->site->getProducts();
        $this->data['categories'] = $this->site->getAllCategories();
        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        if ($this->Owner || $this->Admin || !$this->session->userdata('warehouse_id')) {
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['warehouse_id'] = $warehouse_id;
            $this->data['warehouse'] = $warehouse_id ? $this->site->getWarehouseByID($warehouse_id) : NULL;
        } else {
            $this->data['warehouses'] = NULL;
            $this->data['warehouse_id'] = $this->session->userdata('warehouse_id');
            $this->data['warehouse'] = $this->session->userdata('warehouse_id') ? $this->site->getWarehouseByID($this->session->userdata('warehouse_id')) : NULL;
        }
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('products')));
        $meta = array('page_title' => lang('products'), 'bc' => $bc);
        $this->page_construct('products/index', $meta, $this->data);
    }
	
	function add_procategory()
    {
        $this->load->helper('security');
        $this->form_validation->set_rules('code', lang("category_code"), 'trim|is_unique[categories.code]|required');
        $this->form_validation->set_rules('name', lang("name"), 'required|min_length[3]');
        $this->form_validation->set_rules('userfile', lang("category_image"), 'xss_clean');

        if ($this->form_validation->run() == true) {
            $name = $this->input->post('name');
            $code = $this->input->post('code');

            if ($_FILES['userfile']['size'] > 0) {
                $this->load->library('upload');
                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                $config['max_width'] = $this->Settings->iwidth;
                $config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['encrypt_name'] = TRUE;
                $config['max_filename'] = 25;
                $this->upload->initialize($config);
                if (!$this->upload->do_upload()) {
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
                }
                $photo = $this->upload->file_name;
                //$data['image'] = $photo;
                $this->load->library('image_lib');
                $config['image_library'] = 'gd2';
                $config['source_image'] = $this->upload_path . $photo;
                $config['new_image'] = $this->thumbs_path . $photo;
                $config['maintain_ratio'] = TRUE;
                $config['width'] = $this->Settings->twidth;
                $config['height'] = $this->Settings->theight;
                $this->image_lib->clear();
                $this->image_lib->initialize($config);
                if (!$this->image_lib->resize()) {
                    echo $this->image_lib->display_errors();
                }
                if ($this->Settings->watermark) {
                    $this->image_lib->clear();
                    $wm['source_image'] = $this->upload_path . $photo;
                    $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                    $wm['wm_type'] = 'text';
                    $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                    $wm['quality'] = '100';
                    $wm['wm_font_size'] = '16';
                    $wm['wm_font_color'] = '999999';
                    $wm['wm_shadow_color'] = 'CCCCCC';
                    $wm['wm_vrt_alignment'] = 'top';
                    $wm['wm_hor_alignment'] = 'right';
                    $wm['wm_padding'] = '10';
                    $this->image_lib->initialize($wm);
                    $this->image_lib->watermark();
                }
                $this->image_lib->clear();
                $config = NULL;
            } else {
                $photo = NULL;
            }
        } elseif ($this->input->post('add_category')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect("products/add");
        }

        if ($this->form_validation->run() == true && $this->settings_model->addCategory($name, $code, $photo)) {
            $this->session->set_flashdata('message', lang("category_added"));
        //  redirect("products/add");
			if (strpos($_SERVER['HTTP_REFERER'], 'products/add_procategory') !== false) {
				 redirect("products/add");
			}else{
				 redirect("products/add");
			}
        } else {
            $this->data['error'] = validation_errors() ? validation_errors() : $this->session->flashdata('error');

            $this->data['name'] = array('name' => 'name',
                'id' => 'name',
                'type' => 'text',
                'class' => 'form-control',
                'required' => 'required',
                'value' => $this->form_validation->set_value('name'),
            );
            $this->data['code'] = array('name' => 'code',
                'id' => 'code',
                'type' => 'text',
                'class' => 'form-control',
                'required' => 'required',
                'value' => $this->form_validation->set_value('code'),
            );
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'settings/add_category', $this->data);
        }
    }
	
	function add_subcategory($parent_id = NULL)
    {
        $this->load->helper('security');
        $this->form_validation->set_rules('category', lang("main_category"), 'required');
        $this->form_validation->set_rules('code', lang("subcategory_code"), 'trim|is_unique[categories.code]|is_unique[subcategories.code]|required');
        $this->form_validation->set_rules('name', lang("subcategory_name"), 'required|min_length[2]');
        $this->form_validation->set_rules('userfile', lang("category_image"), 'xss_clean');

        if ($this->form_validation->run() == true) {
            $name = $this->input->post('name');
            $code = $this->input->post('code');
            $category = $this->input->post('category');
            if ($_FILES['userfile']['size'] > 0) {
                $this->load->library('upload');
                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                $config['max_width'] = $this->Settings->iwidth;
                $config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['encrypt_name'] = TRUE;
                $config['max_filename'] = 25;
                $this->upload->initialize($config);
                if (!$this->upload->do_upload()) {
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
                }
                $photo = $this->upload->file_name;
                //$data['image'] = $photo;
                $this->load->library('image_lib');
                $config['image_library'] = 'gd2';
                $config['source_image'] = $this->upload_path . $photo;
                $config['new_image'] = $this->thumbs_path . $photo;
                $config['maintain_ratio'] = TRUE;
                $config['width'] = $this->Settings->twidth;
                $config['height'] = $this->Settings->theight;
                $this->image_lib->clear();
                $this->image_lib->initialize($config);
                if (!$this->image_lib->resize()) {
                    echo $this->image_lib->display_errors();
                }
                if ($this->Settings->watermark) {
                    $this->image_lib->clear();
                    $wm['source_image'] = $this->upload_path . $photo;
                    $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                    $wm['wm_type'] = 'text';
                    $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                    $wm['quality'] = '100';
                    $wm['wm_font_size'] = '16';
                    $wm['wm_font_color'] = '999999';
                    $wm['wm_shadow_color'] = 'CCCCCC';
                    $wm['wm_vrt_alignment'] = 'top';
                    $wm['wm_hor_alignment'] = 'right';
                    $wm['wm_padding'] = '10';
                    $this->image_lib->initialize($wm);
                    $this->image_lib->watermark();
                }
                $this->image_lib->clear();
                $config = NULL;
            } else {
                $photo = NULL;
            }
        } elseif ($this->input->post('add_subcategory')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect("products/add");
        }

        if ($this->form_validation->run() == true && $this->settings_model->addSubCategory($category, $name, $code, $photo)) {
            $this->session->set_flashdata('message', lang("subcategory_added"));
            redirect("products/add", 'refresh');
        } else {
            $this->data['error'] = validation_errors() ? validation_errors() : $this->session->flashdata('error');

            $this->data['name'] = array('name' => 'name',
                'id' => 'name',
                'type' => 'text', 'class' => 'form-control',
                'class' => 'form-control',
                'required' => 'required',
                'value' => $this->form_validation->set_value('name'),
            );
            $this->data['code'] = array('name' => 'code',
                'id' => 'code',
                'type' => 'text',
                'class' => 'form-control',
                'required' => 'required',
                'value' => $this->form_validation->set_value('code'),
            );
            $this->data['parent_id'] = $parent_id;
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['categories'] = $this->settings_model->getAllCategories();
            $this->load->view($this->theme . 'settings/add_subcategory', $this->data);
        }
    }

    function getProducts($warehouse_id = NULL)
    {
        $this->erp->checkPermissions('index');
        
        if ($this->input->get('product')) {
            $product = $this->input->get('product');
        } else {
            $product = NULL;
        }
        if ($this->input->get('category')) {
            $category = $this->input->get('category');
        } else {
            $category = NULL;
        }
		if ($this->input->get('product_type')) {
            $product_type = $this->input->get('product_type');
        } else {
            $product_type = NULL;
        }
        if ($this->input->get('start_date')) {
            $start_date = $this->input->get('start_date');
        } else {
            $start_date = NULL;
        }
        if ($this->input->get('end_date')) {
            $end_date = $this->input->get('end_date');
        } else {
            $end_date = NULL;
        }

        if ((! $this->Owner || ! $this->Admin) && ! $warehouse_id) {
            $user = $this->site->getUser();
            $warehouse_id = $user->warehouse_id;
        }
		if($this->GP['all_warehouses']){
			 $warehouse_id = "";
		}
		
        $detail_link = anchor('products/view/$1', '<i class="fa fa-file-text-o"></i> ' . lang('product_details'));
        $delete_link = "<a href='products/delete/$1' class='tip po' title='<b>" . $this->lang->line("delete_product") . "</b>' data-content=\"<p>"
            . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete1' id='a__$1' href='" . site_url('products/delete/$1') . "'>"
            . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i> "
            . lang('delete_product') . "</a>";
        $single_barcode = anchor_popup('products/single_barcode/$1/' . ($warehouse_id ? $warehouse_id : ''), '<i class="fa fa-print"></i> ' . lang('print_barcode'), $this->popup_attributes);
        $single_label = anchor_popup('products/single_label/$1/' . ($warehouse_id ? $warehouse_id : ''), '<i class="fa fa-print"></i> ' . lang('print_label'), $this->popup_attributes);
        $action = '<div class="text-center"><div class="btn-group text-left">'
            . '<button type="button" class="btn btn-default btn-xs btn-primary dropdown-toggle" data-toggle="dropdown">'
            . lang('actions') . ' <span class="caret"></span></button>
		<ul class="dropdown-menu pull-right" role="menu">
			<li>' . $detail_link . '</li>
			<li><a href="' . site_url('products/add/$1') . '"><i class="fa fa-plus-square"></i> ' . lang('duplicate_product') . '</a></li>
			<li><a href="' . site_url('products/edit/$1') . '"><i class="fa fa-edit"></i> ' . lang('edit_product') . '</a></li>';
        if ($warehouse_id) {
            $action .= '<li><a href="' . site_url('products/set_rack/$1/' . $warehouse_id) . '" data-toggle="modal" data-target="#myModal"><i class="fa fa-bars"></i> '
                . lang('set_rack') . '</a></li>';
        }
        $action .= '<li><a href="' . site_url() . 'assets/uploads/$2" data-type="image" data-toggle="lightbox"><i class="fa fa-file-photo-o"></i> '
            . lang('view_image') . '</a></li>
			<li>' . $single_barcode . '</li>
			<li>' . $single_label . '</li>
			<li><a href="' . site_url('products/add_adjustment/$1/' . ($warehouse_id ? $warehouse_id : '')) . '" data-toggle="modal" data-target="#myModal"><i class="fa fa-filter"></i> '
            . lang('adjust_quantity') . '</a></li>
				<li class="divider"></li>
				<li>' . $delete_link . '</li>
			</ul>
		</div></div>';
        $this->load->library('datatables');
        if ($warehouse_id) {
            $this->datatables
            ->select($this->db->dbprefix('products') . ".id as productid, " . $this->db->dbprefix('products') . ".image as image, " . $this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as name, " . $this->db->dbprefix('categories') . ".name as cname, cost as cost, price as price, COALESCE(wp.quantity, 0) as quantity, ".$this->db->dbprefix("units").".name as unit, wp.rack as rack, alert_quantity", FALSE)		
            ->from('products');
			
            if ($this->Settings->display_all_products) {
                $this->datatables->join("( SELECT * from {$this->db->dbprefix('warehouses_products')} WHERE warehouse_id = {$warehouse_id}) wp", 'products.id=wp.product_id', 'left');
            } else {
                $this->datatables->join('warehouses_products wp', 'products.id=wp.product_id', 'left')
                ->where('wp.warehouse_id', $warehouse_id);
                //->where('wp.quantity !=', 0);
            }
            $this->datatables->join('categories', 'products.category_id=categories.id', 'left')
			->join('units', 'products.unit=units.id', 'left')
            ->group_by("products.id");
        } else {
            $this->datatables
                ->select($this->db->dbprefix('products') . ".id as productid, " . $this->db->dbprefix('products') . ".image as image, " . $this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as name, " . $this->db->dbprefix('categories') . ".name as cname, cost as cost, price as price, COALESCE(quantity, 0) as quantity, ((CASE WHEN ".$this->db->dbprefix('products').".unit > 0 THEN ".$this->db->dbprefix('units').".name ELSE ".$this->db->dbprefix('products').".unit END)) as unit, '' as rack, alert_quantity", FALSE)
                ->from('products')
                ->join('categories', 'products.category_id=categories.id', 'left')
				->join('units', 'products.unit=units.id', 'left');
            $this->datatables->group_by("products.id");
        }
        if (!$this->Owner && !$this->Admin) {
            if (!$this->session->userdata('show_cost')) {
                $this->datatables->unset_column("cost");
            }
            if (!$this->session->userdata('show_price')) {
                $this->datatables->unset_column("price");
            }
        }
        /*if ($product) {
            $this->datatables->where($this->db->dbprefix('products').'.id LIKE "%' . $product . '%" OR '.$this->db->dbprefix('products').'.code LIKE "%' . $product . '%" OR '.$this->db->dbprefix('products').'.name LIKE "%' . $product . '%"');
        }*/
		if ($product) {
            $this->datatables->where($this->db->dbprefix('products') . ".id", $product);
        }
        if ($category) {
            $this->datatables->where($this->db->dbprefix('products') . ".category_id", $category);
        }
		if ($product_type) {
            $this->datatables->where($this->db->dbprefix('products') . ".inactived", $product_type);
        }else{
			$this->datatables->where($this->db->dbprefix('products') . ".inactived !=", '1');
		}
			
        $this->datatables->add_column("Actions", $action, "productid, image, code, name");
        echo $this->datatables->generate();
    }

    function set_rack($product_id = NULL, $warehouse_id = NULL)
    {
        $this->erp->checkPermissions('edit', true);

        $this->form_validation->set_rules('rack', lang("rack_location"), 'trim|required');

        if ($this->form_validation->run() == true) {
            $data = array('rack' => $this->input->post('rack'),
                'product_id' => $product_id,
                'warehouse_id' => $warehouse_id,
            );
        } elseif ($this->input->post('set_rack')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect("products");
        }

        if ($this->form_validation->run() == true && $this->products_model->setRack($data)) {
            $this->session->set_flashdata('message', lang("rack_set"));
            redirect("products/" . $warehouse_id);
        } else {
            $this->data['error'] = validation_errors() ? validation_errors() : $this->session->flashdata('error');
            $this->data['warehouse_id'] = $warehouse_id;
            $this->data['product'] = $this->site->getProductByID($product_id);
            $wh_pr = $this->products_model->getProductQuantity($product_id, $warehouse_id);
            $this->data['rack'] = $wh_pr['rack'];
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'products/set_rack', $this->data);

        }
    }

    function product_barcode($product_code = NULL, $bcs = 'code128', $height = 60)
    {
        return "<img src='" . site_url('products/gen_barcode/' . $product_code . '/' . $bcs . '/' . $height) . "' alt='{$product_code}' class='bcimg' />";
    }

    function barcode($product_code = NULL, $bcs = 'code128', $height = 60)
    {
        return site_url('products/gen_barcode/' . $product_code . '/' . $bcs . '/' . $height);
    }

    function gen_barcode($product_code = NULL, $bcs = 'code128', $height = 60, $text = 1)
    {
        $drawText = ($text != 1) ? FALSE : TRUE;
        $this->load->library('zend');
        $this->zend->load('Zend/Barcode');
        $barcodeOptions = array('text' => $product_code, 'barHeight' => $height, 'drawText' => $drawText, 'factor' => 1);
        $rendererOptions = array('imageType' => 'png', 'horizontalPosition' => 'center', 'verticalPosition' => 'middle');
        $imageResource = Zend_Barcode::render($bcs, 'image', $barcodeOptions, $rendererOptions);
        return $imageResource;

    }

    function single_barcode($product_id = NULL, $warehouse_id = NULL)
    {
        $this->erp->checkPermissions('barcode', true);

        $product = $this->products_model->getProductByID($product_id);
        $currencies = $this->site->getAllCurrencies();

        $this->data['product'] = $product;
        $options = $this->products_model->getProductOptionsWithWH($product_id);
        if( ! $options) {
            $options = $this->products_model->getProductOptions($product_id);
        }
        $table = '';
        if (!empty($options)) {
            $r = 1;
            foreach ($options as $option) {
                $quantity = $option->wh_qty;
                $warehouse = $this->site->getWarehouseByID(($option->quantity <= 0) ? $this->Settings->default_warehouse :$option->warehouse_id);
                $table .= '<h3 class="'.($option->quantity ? '' : 'text-danger').'">'.$warehouse->name.' ('.$warehouse->code.') - '.$product->name.' - '.$option->name.' ('.lang('quantity').': '.$quantity.')</h3>';
                $table .= '<table class="table table-bordered barcodes"><tbody><tr>';
                for($i=0; $i < $quantity; $i++) {

                    $table .= '<td style="width: 20px;"><table class="table-barcode"><tbody><tr><td colspan="2" class="bold">' . $this->Settings->site_name . '</td></tr><tr><td colspan="2">' . $product->name . ' - '.$option->name.'</td></tr><tr><td colspan="2" class="text-center bc">' . $this->product_barcode($product->code . $this->Settings->barcode_separator . $option->id, 'code128', 60) . '</td></tr>';
                    foreach ($currencies as $currency) {
                        $table .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($product->price * $currency->rate) . '</td></tr>';
                    }
                    $table .= '</tbody></table>';
                    $table .= '</td>';
                    $table .= ((bool)($i & 1)) ? '</tr><tr>' : '';

                }
                $r++;
                $table .= '</tr></tbody></table><hr>';
            }
        } else {
            $table .= '<table class="table table-bordered barcodes"><tbody><tr>';
            $num = $product->quantity;
            for ($r = 1; $r <= $num; $r++) {
                if ($r != 1) {
                    $rw = (bool)($r & 1);
                    $table .= $rw ? '</tr><tr>' : '';
                }
                $table .= '<td style="width: 20px;"><table class="table-barcode"><tbody><tr><td colspan="2" class="bold">' . $this->Settings->site_name . '</td></tr><tr><td colspan="2">' . $product->name . '</td></tr><tr><td colspan="2" class="text-center bc">' . $this->product_barcode($product->code, $product->barcode_symbology, 60) . '</td></tr>';
                foreach ($currencies as $currency) {
                    $table .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($product->price * $currency->rate) . '</td></tr>';
                }
                $table .= '</tbody></table>';
                $table .= '</td>';
            }
            $table .= '</tr></tbody></table>';
        }

        $this->data['table'] = $table;

        $this->data['page_title'] = lang("print_barcodes");
        $this->load->view($this->theme . 'products/single_barcode', $this->data);
    }

    function single_label($product_id = NULL, $warehouse_id = NULL)
    {
        $this->erp->checkPermissions('barcode', true);

        $product = $this->products_model->getProductByID($product_id);
        $currencies = $this->site->getAllCurrencies();

        $this->data['product'] = $product;
        $options = $this->products_model->getProductOptionsWithWH($product_id);

        $table = '';
        if (!empty($options)) {
            $r = 1;
            foreach ($options as $option) {
                $quantity = $option->wh_qty;
                $warehouse = $this->site->getWarehouseByID($option->warehouse_id);
                $table .= '<h3 class="'.($option->quantity ? '' : 'text-danger').'">'.$warehouse->name.' ('.$warehouse->code.') - '.$product->name.' - '.$option->name.' ('.lang('quantity').': '.$quantity.')</h3>';
                $table .= '<table class="table table-bordered barcodes"><tbody><tr>';
                for($i=0; $i < $quantity; $i++) {
                    if ($i % 4 == 0 && $i > 3) {
                        $table .= '</tr><tr>';
                    }
                    $table .= '<td style="width: 20px;"><table class="table-barcode"><tbody><tr><td colspan="2" class="bold">' . $this->Settings->site_name . '</td></tr><tr><td colspan="2">' . $product->name . ' - '.$option->name.'</td></tr><tr><td colspan="2" class="text-center bc">' . $this->product_barcode($product->code . $this->Settings->barcode_separator . $option->id, 'code128', 30) . '</td></tr>';
                    foreach ($currencies as $currency) {
                        $table .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($product->price * $currency->rate) . '</td></tr>';
                    }
                    $table .= '</tbody></table>';
                    $table .= '</td>';
                }
                $r++;
                $table .= '</tr></tbody></table><hr>';
            }
        } else {
            $table .= '<table class="table table-bordered barcodes"><tbody><tr>';
            $num = $product->quantity;
            for ($r = 1; $r <= $num; $r++) {
                $table .= '<td style="width: 20px;"><table class="table-barcode"><tbody><tr><td colspan="2" class="bold">' . $this->Settings->site_name . '</td></tr><tr><td colspan="2">' . $product->name . '</td></tr><tr><td colspan="2" class="text-center bc">' . $this->product_barcode($product->code, $product->barcode_symbology, 30) . '</td></tr>';
                foreach ($currencies as $currency) {
                    $table .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($product->price * $currency->rate) . '</td></tr>';
                }
                $table .= '</tbody></table>';
                $table .= '</td>';
                if ($r % 4 == 0 && $r > 3) {
                    $table .= '</tr><tr>';
                }
            }
            $table .= '</tr></tbody></table>';
        }

        $this->data['table'] = $table;
        $this->data['page_title'] = lang("barcode_label");
        $this->load->view($this->theme . 'products/single_label', $this->data);
    }

    function single_label2($product_id = NULL, $warehouse_id = NULL)
    {
        $this->erp->checkPermissions('barcode', true);

        $pr = $this->products_model->getProductByID($product_id);
        $currencies = $this->site->getAllCurrencies();

        $this->data['product'] = $pr;
        $options = $this->products_model->getProductOptionsWithWH($product_id);
        $html = "";

        if (!empty($options)) {
            foreach ($options as $option) {
                for ($r = 1; $r <= $option->wh_qty; $r++) {
                    $html .= '<div class="labels"><strong>' . $pr->name . ' - '.$option->name.'</strong><br>' . $this->product_barcode($pr->code . $this->Settings->barcode_separator . $option->id, 'code128', 25) . '<br><span class="price">'.lang('price') .': ' .$this->Settings->default_currency. ' ' . $this->erp->formatMoney($pr->price) . '</span></div>';
                }
            }
        } else {
            for ($r = 1; $r <= $pr->quantity; $r++) {
                $html .= '<div class="labels"><strong>' . $pr->name . '</strong><br>' . $this->product_barcode($pr->code, $pr->barcode_symbology, 25) . '<br><span class="price">'.lang('price') .': ' .$this->Settings->default_currency. ' ' . $this->erp->formatMoney($pr->price) . '</span></div>';
            }
        }

        $this->data['html'] = $html;
        $this->data['page_title'] = lang("barcode_label");
        $this->load->view($this->theme . 'products/single_label2', $this->data);
    }

    function print_barcodes($product_id = NULL)
    {
        $this->erp->checkPermissions('barcode', true);

        $this->form_validation->set_rules('style', lang("style"), 'required');

        if ($this->form_validation->run() == true) {

            $style = $this->input->post('style');
            $bci_size = ($style == 10 || $style == 12 ? 50 : ($style == 14 || $style == 18 ? 30 : 20));
            $currencies = $this->site->getAllCurrencies();
            $s = isset($_POST['product']) ? sizeof($_POST['product']) : 0;
            if ($s < 1) {
                $this->session->set_flashdata('error', lang('no_product_selected'));
                redirect("products/print_barcodes");
            }
            for ($m = 0; $m < $s; $m++) {
                $pid = $_POST['product'][$m];
                $quantity = $_POST['quantity'][$m];
                $product = $this->products_model->getProductWithCategory($pid);
                
                if ($variants = $this->products_model->getProductOptions($pid)) {
                    foreach ($variants as $option) {
                        if ($this->input->post('vt_'.$product->id.'_'.$option->id)) {
                            $barcodes[] = array(
                                'site' => $this->input->post('site_name') ? $this->Settings->site_name : FALSE,
                                'name' => $this->input->post('product_name') ? $product->name.' - '.$option->name : FALSE,
                                'image' => $this->input->post('product_image') ? $product->image : FALSE,
                                'barcode' => $this->product_barcode($product->code . $this->Settings->barcode_separator . $option->id, 'code128', $bci_size),
                                'price' => $this->input->post('price') ?  $this->erp->formatMoney($option->price != 0 ? $option->price : $product->price) : FALSE,
                                'unit' => $this->input->post('unit') ? $product->unit : FALSE,
                                'category' => $this->input->post('category') ? $product->category : FALSE,
                                'currencies' => $this->input->post('currencies'),
                                'variants' => $this->input->post('variants') ? $variants : FALSE,
                                'quantity' => $quantity
                                );
                        }
                    }
                } else {
                    $barcodes[] = array(
                        'site' => $this->input->post('site_name') ? $this->Settings->site_name : FALSE,
                        'name' => $this->input->post('product_name') ? $product->name : FALSE,
                        'image' => $this->input->post('product_image') ? $product->image : FALSE,
                        'barcode' => $this->product_barcode($product->code, $product->barcode_symbology, $bci_size),
                        'price' => $this->input->post('price') ?  $this->erp->formatMoney($product->price) : FALSE,
                        'unit' => $this->input->post('unit') ? $product->unit : FALSE,
                        'category' => $this->input->post('category') ? $product->category : FALSE,
                        'currencies' => $this->input->post('currencies'),
                        'variants' => FALSE,
                        'quantity' => $quantity
                    );
                }
            }
            $this->data['barcodes'] = $barcodes;
            $this->data['currencies'] = $currencies;
            $this->data['style'] = $style;
            $this->data['items'] = false;
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_barcodes')));
            $meta = array('page_title' => lang('print_barcodes'), 'bc' => $bc);
            $this->page_construct('products/print_barcodes', $meta, $this->data);

        } else {

            if ($this->input->get('purchase') || $this->input->get('transfer')) {
                if ($this->input->get('purchase')) {
                    $purchase_id = $this->input->get('purchase', TRUE);
                    $items = $this->products_model->getPurchaseItems($purchase_id);
                } elseif ($this->input->get('transfer')) {
                    $transfer_id = $this->input->get('transfer', TRUE);
                    $items = $this->products_model->getTransferItems($transfer_id);
                }
                if ($items) {
                    foreach ($items as $item) {
                        if ($row = $this->products_model->getProductByID($item->product_id)) {
                            $selected_variants = false;
                            if ($variants = $this->products_model->getProductOptions($row->id)) {
                                foreach ($variants as $variant) {
                                    $selected_variants[$variant->id] = isset($pr[$row->id]['selected_variants'][$variant->id]) && !empty($pr[$row->id]['selected_variants'][$variant->id]) ? 1 : ($variant->id == $item->option_id ? 1 : 0);
                                }
                            }
                            $pr[$row->id] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => $item->quantity, 'variants' => $variants, 'selected_variants' => $selected_variants);
                        }
                    }
                    $this->data['message'] = lang('products_added_to_list');
                }
            }

            if ($this->input->get('category')) {
                if ($products = $this->products_model->getCategoryProducts($this->input->get('category'))) {
                    foreach ($products as $row) {
                        $selected_variants = false;
                        if ($variants = $this->products_model->getProductOptions($row->id)) {
                            foreach ($variants as $variant) {
                                $selected_variants[$variant->id] = $variant->quantity > 0 ? 1 : 0;
                            }
                        }
                        $pr[$row->id] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => $row->quantity, 'variants' => $variants, 'selected_variants' => $selected_variants);
                    }
                    $this->data['message'] = lang('products_added_to_list');
                } else {
                    $pr = array();
                    $this->session->set_flashdata('error', lang('no_product_found'));
                }
            }

            if ($this->input->get('subcategory')) {
                if ($products = $this->products_model->getSubCategoryProducts($this->input->get('subcategory'))) {
                    foreach ($products as $row) {
                        $selected_variants = false;
                        if ($variants = $this->products_model->getProductOptions($row->id)) {
                            foreach ($variants as $variant) {
                                $selected_variants[$variant->id] = $variant->quantity > 0 ? 1 : 0;
                            }
                        }
                        $pr[$row->id] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => $row->quantity, 'variants' => $variants, 'selected_variants' => $selected_variants);
                    }
                    $this->data['message'] = lang('products_added_to_list');
                } else {
                    $pr = array();
                    $this->session->set_flashdata('error', lang('no_product_found'));
                }
            }

            $this->data['items'] = isset($pr) ? json_encode($pr) : false;
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_barcodes')));
            $meta = array('page_title' => lang('print_barcodes'), 'bc' => $bc);
            $this->page_construct('products/print_barcodes', $meta, $this->data);
        }
    }


	
	
	
    /* ------------------------------------------------------- */

    function add($id = NULL)
    {
        $this->erp->checkPermissions();
        $this->load->helper('security');
        $warehouses = $this->site->getAllWarehouses();
        if ($this->input->post('type') == 'standard') {
            $this->form_validation->set_rules('cost', lang("product_cost"), 'required');
        }
        if ($this->input->post('barcode_symbology') == 'ean13') {
            $this->form_validation->set_rules('code', lang("product_code"), 'min_length[13]|max_length[13]');
        }
		$this->form_validation->set_rules('code', lang("product_code"), 'is_unique[products.code]');
        $this->form_validation->set_rules('product_image', lang("product_image"), 'xss_clean');
        $this->form_validation->set_rules('digital_file', lang("digital_file"), 'xss_clean');
        $this->form_validation->set_rules('userfile', lang("product_gallery_images"), 'xss_clean');
		$warehouse_qty = array();
        if ($this->form_validation->run() == true) {
            $tax_rate = $this->input->post('tax_rate') ? $this->site->getTaxRateByID($this->input->post('tax_rate')) : NULL;
            if($this->input->post('inactive')) {
				$inactived = $this->input->post('inactive');
			} else {
				$inactived = 0;
			}
			$data = array(
                'code' => $this->input->post('code'),
                'barcode_symbology' => $this->input->post('barcode_symbology'),
                'name' => $this->input->post('name'),
                'type' => $this->input->post('type'),
                'category_id' => $this->input->post('category'),
                'subcategory_id' => $this->input->post('subcategory') ? $this->input->post('subcategory') : NULL,
                'cost' => $this->erp->formatDecimal($this->input->post('cost')),
                'price' => $this->erp->formatDecimal($this->input->post('price')),
                'unit' => $this->input->post('unit'),
                'tax_rate' => $this->input->post('tax_rate'),
                'tax_method' => $this->input->post('tax_method'),
                'alert_quantity' => $this->input->post('alert_quantity'),
                'track_quantity' => $this->input->post('track_quantity') ? $this->input->post('track_quantity') : '0',
                'details' => $this->input->post('details'),
                'product_details' => $this->input->post('product_details'),
                'supplier1' => $this->input->post('supplier'),
                'supplier1price' => $this->erp->formatDecimal($this->input->post('supplier_price')),
                'supplier2' => $this->input->post('supplier_2'),
                'supplier2price' => $this->erp->formatDecimal($this->input->post('supplier_2_price')),
                'supplier3' => $this->input->post('supplier_3'),
                'supplier3price' => $this->erp->formatDecimal($this->input->post('supplier_3_price')),
                'supplier4' => $this->input->post('supplier_4'),
                'supplier4price' => $this->erp->formatDecimal($this->input->post('supplier_4_price')),
                'supplier5' => $this->input->post('supplier_5'),
                'supplier5price' => $this->erp->formatDecimal($this->input->post('supplier_5_price')),
                'cf1' => $this->input->post('cf1'),
                'cf2' => $this->input->post('cf2'),
                'cf3' => $this->input->post('cf3'),
                'cf4' => $this->input->post('cf4'),
                'cf5' => $this->input->post('cf5'),
                'cf6' => $this->input->post('cf6'),
				'promotion' => $this->input->post('promotion'),
                'promo_price' => $this->erp->formatDecimal($this->input->post('promo_price')),
                'start_date' => $this->erp->fsd($this->input->post('start_date')),
                'end_date' => $this->erp->fsd($this->input->post('end_date')),
                'supplier1_part_no' => $this->input->post('supplier_part_no'),
                'supplier2_part_no' => $this->input->post('supplier_2_part_no'),
                'supplier3_part_no' => $this->input->post('supplier_3_part_no'),
                'supplier4_part_no' => $this->input->post('supplier_4_part_no'),
                'supplier5_part_no' => $this->input->post('supplier_5_part_no'),           
				'currentcy_code'    => $this->input->post('currency'),
				'inactived' => $inactived,
				'brand_id' => $this->input->post('brand')
			);
			
			$related_straps = $this->input->post('related_strap');
			for($i=0; $i<sizeof($related_straps); $i++) {
				$product_name = $this->site->getProductByCode($related_straps[$i]);
				$related_products[] = array(
											'product_code' => $this->input->post('code'),
											'related_product_code' => $related_straps[$i],
											'product_name' => $product_name->name,
											);
			}
			//$this->erp->print_arrays($related_products);
            $this->load->library('upload');
            if ($this->input->post('type') == 'standard') {
                $wh_total_quantity = 0;
                $pv_total_quantity = 0;
                for ($s = 2; $s > 5; $s++) {
                    $data['suppliers' . $s] = $this->input->post('supplier_' . $s);
                    $data['suppliers' . $s . 'price'] = $this->input->post('supplier_' . $s . '_price');
                }
                foreach ($warehouses as $warehouse) {
                    if ($this->input->post('wh_qty_' . $warehouse->id)) {
                        $warehouse_qty[] = array(
                            'warehouse_id' => $this->input->post('wh_' . $warehouse->id),
                            'quantity' => $this->input->post('wh_qty_' . $warehouse->id),
                            'rack' => $this->input->post('rack_' . $warehouse->id) ? $this->input->post('rack_' . $warehouse->id) : NULL
                        );
                        $wh_total_quantity += $this->input->post('wh_qty_' . $warehouse->id);
                    }
                }

                if ($this->input->post('attributes')) {
                    $a = sizeof($_POST['attr_name']);
                    for ($r = 0; $r <= $a; $r++) {
                        if (isset($_POST['attr_name'][$r])) {
							if(isset($_POST['attr_warehouse'][$r]) == NULL){
								$_POST['attr_warehouse'][$r] = '';
							}
							if(isset($_POST['attr_quantity_unit'][$r]) == NULL){
								$_POST['attr_quantity_unit'][$r] = '';
							}
							if(isset($_POST['attr_quantity'][$r]) == NULL){
								$_POST['attr_quantity'][$r] = '';
							}
							if(isset($_POST['attr_cost'][$r]) == NULL){
								$_POST['attr_cost'][$r] = '';
							}
							if(isset($_POST['attr_price'][$r]) == NULL){
								$_POST['attr_price'][$r] = '';
							}
                            $product_attributes[] = array(
                                'name' => $_POST['attr_name'][$r],
                                'warehouse_id' => $_POST['attr_warehouse'][$r],
								'qty_unit' => $_POST['attr_quantity_unit'][$r],
                                'quantity' => $_POST['attr_quantity'][$r],
                                'cost' => $_POST['attr_cost'][$r],
                                'price' => $_POST['attr_price'][$r],
                            );
                            $pv_total_quantity += $_POST['attr_quantity'][$r];
                        }
                    }
                } else {
                    $product_attributes = NULL;
                }
				
				/** Check If Quantity and stock is equal
                if ($wh_total_quantity != $pv_total_quantity && $pv_total_quantity != 0) {
                    $this->form_validation->set_rules('wh_pr_qty_issue', 'wh_pr_qty_issue', 'required');
                    $this->form_validation->set_message('required', lang('wh_pr_qty_issue'));
                } 
				**/
            } else {
                $warehouse_qty = NULL;
                $product_attributes = NULL;
            }

            if ($this->input->post('type') == 'service') {
                $data['track_quantity'] = 0;
            } elseif ($this->input->post('type') == 'combo') {
                $total_price = 0;
                $c = sizeof($_POST['combo_item_code']) - 1;
                for ($r = 0; $r <= $c; $r++) {
                    if (isset($_POST['combo_item_code'][$r]) && isset($_POST['combo_item_quantity_unit'][$r]) && isset($_POST['combo_item_price'][$r])) {
                        $items[] = array(
                            'item_code' => $_POST['combo_item_code'][$r],
							//'qty_unit' => $_POST['combo_item_quantity_unit'][$r],
							'quantity' => $_POST['combo_item_quantity_unit'][$r],
                            'unit_price' => $_POST['combo_item_price'][$r],
                        );
                    }
                    $total_price += $_POST['combo_item_price'][$r] * $_POST['combo_item_quantity_unit'][$r];
                }
				//$this->erp->print_arrays($items);
                /* if ($this->erp->formatDecimal($total_price) != $this->erp->formatDecimal($this->input->post('price'))) {
                    $this->form_validation->set_rules('combo_price', 'combo_price', 'required');
                    $this->form_validation->set_message('required', lang('pprice_not_match_ciprice'));
                } */
                $data['track_quantity'] = 0;
            } elseif ($this->input->post('type') == 'digital') {
                if ($_FILES['digital_file']['size'] > 0) {
                    $config['upload_path'] = $this->digital_upload_path;
                    $config['allowed_types'] = $this->digital_file_types;
                    $config['max_size'] = $this->allowed_file_size;
                    $config['overwrite'] = FALSE;
                    $config['encrypt_name'] = TRUE;
                    $config['max_filename'] = 25;
                    $this->upload->initialize($config);
                    if (!$this->upload->do_upload('digital_file')) {
                        $error = $this->upload->display_errors();
                        $this->session->set_flashdata('error', $error);
                        redirect("products/add");
                    }
                    $file = $this->upload->file_name;
                    $data['file'] = $file;
                } else {
                    $this->form_validation->set_rules('digital_file', lang("digital_file"), 'required');
                }
                $config = NULL;
                $data['track_quantity'] = 0;
            }
            if (!isset($items)) {
                $items = NULL;
            }
            if ($_FILES['product_image']['size'] > 0) {

                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                //$config['max_width'] = $this->Settings->iwidth;
                //$config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['max_filename'] = 25;
                $config['encrypt_name'] = TRUE;
                $this->upload->initialize($config);
                if (!$this->upload->do_upload('product_image')) {
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("products/add");
                }
                $photo = $this->upload->file_name;
                $data['image'] = $photo;
                $this->load->library('image_lib');
                $config['image_library'] = 'gd2';
                $config['source_image'] = $this->upload_path . $photo;
                $config['new_image'] = $this->thumbs_path . $photo;

                $config['maintain_ratio'] = TRUE;
                //$config['width'] = $this->Settings->twidth;
                //$config['height'] = $this->Settings->theight;
				$config['width'] = $this->Settings->iwidth;
                $config['height'] = $this->Settings->iheight;
                $this->image_lib->clear();
                $this->image_lib->initialize($config);
                if (!$this->image_lib->resize()) {
                    echo $this->image_lib->display_errors();
                }
				copy($config['new_image'] , $config['source_image']);
                if ($this->Settings->watermark) {
                    $this->image_lib->clear();
                    $wm['source_image'] = $this->upload_path . $photo;
                    $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                    $wm['wm_type'] = 'text';
                    $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                    $wm['quality'] = '100';
                    $wm['wm_font_size'] = '16';
                    $wm['wm_font_color'] = '999999';
                    $wm['wm_shadow_color'] = 'CCCCCC';
                    $wm['wm_vrt_alignment'] = 'top';
                    $wm['wm_hor_alignment'] = 'right';
                    $wm['wm_padding'] = '10';
                    $this->image_lib->initialize($wm);
                    $this->image_lib->watermark();
                }
                $this->image_lib->clear();
                $config = NULL;
            }

            if ($_FILES['userfile']['name'][0] != "") {

                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                //$config['max_width'] = $this->Settings->iwidth;
                //$config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['encrypt_name'] = TRUE;
                $config['max_filename'] = 25;
                $files = $_FILES;
                $cpt = count($_FILES['userfile']['name']);
                for ($i = 0; $i < $cpt; $i++) {

                    $_FILES['userfile']['name'] = $files['userfile']['name'][$i];
                    $_FILES['userfile']['type'] = $files['userfile']['type'][$i];
                    $_FILES['userfile']['tmp_name'] = $files['userfile']['tmp_name'][$i];
                    $_FILES['userfile']['error'] = $files['userfile']['error'][$i];
                    $_FILES['userfile']['size'] = $files['userfile']['size'][$i];

                    $this->upload->initialize($config);

                    if (!$this->upload->do_upload()) {
                        $error = $this->upload->display_errors();
                        $this->session->set_flashdata('error', $error);
                        redirect("products/add");
                    } else {
                        $pho = $this->upload->file_name;

                        $photos[] = $pho;

                        $this->load->library('image_lib');
                        $config['image_library'] = 'gd2';
                        $config['source_image'] = $this->upload_path . $pho;
                        $config['new_image'] = $this->thumbs_path . $pho;
                        $config['maintain_ratio'] = TRUE;
                        //$config['width'] = $this->Settings->twidth;
                        //$config['height'] = $this->Settings->theight;
						$config['width'] = $this->Settings->iwidth;
						$config['height'] = $this->Settings->iheight;

                        $this->image_lib->initialize($config);
						copy($config['new_image'] , $config['source_image']);
                        if (!$this->image_lib->resize()) {
                            echo $this->image_lib->display_errors();
                        }

                        if ($this->Settings->watermark) {
                            $this->image_lib->clear();
                            $wm['source_image'] = $this->upload_path . $pho;
                            $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                            $wm['wm_type'] = 'text';
                            $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                            $wm['quality'] = '100';
                            $wm['wm_font_size'] = '16';
                            $wm['wm_font_color'] = '999999';
                            $wm['wm_shadow_color'] = 'CCCCCC';
                            $wm['wm_vrt_alignment'] = 'top';
                            $wm['wm_hor_alignment'] = 'right';
                            $wm['wm_padding'] = '10';
                            $this->image_lib->initialize($wm);
                            $this->image_lib->watermark();
                        }
                        $this->image_lib->clear();
                    }
                }
                $config = NULL;
            } else {
                $photos = NULL;
            }
            $data['quantity'] = isset($wh_total_quantity) ? $wh_total_quantity : 0;
            // $this->erp->print_arrays($data, $warehouse_qty, $product_attributes);
        }

        if ($this->form_validation->run() == true && $this->products_model->addProduct($data, $items, $warehouse_qty, $product_attributes, $photos, $related_products)) {
            $this->session->set_flashdata('message', lang("product_added"));
			if (strpos($_SERVER['HTTP_REFERER'], 'products/add') !== false) {
				redirect('products');
			}else{
				redirect('purchases/add');
			}
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			
			$this->data['currencies'] = $this->products_model->getAllCurrencies();
            $this->data['categories'] = $this->site->getAllCategories();
			$this->data['brands'] = $this->site->getAllBrands();
            $this->data['tax_rates'] = $this->site->getAllTaxRates();
            $this->data['warehouses'] = $warehouses;
			
            $this->data['warehouses_products'] = $id ? $this->products_model->getAllWarehousesWithPQ($id) : NULL;
            $this->data['product'] = $id ? $this->products_model->getProductByID($id) : NULL;
			$this->data['products'] = $this->site->getAllProducts();
            $this->data['variants'] = $this->products_model->getAllVariants();
			
			/** Project **/
			$this->data['shops'] = $this->products_model->getProjects();
			$this->data['unit'] = $this->products_model->getUnits();
            $this->data['combo_items'] = ($id && $this->data['product']->type == 'combo') ? $this->products_model->getProductComboItems($id) : NULL;
            $this->data['product_options'] = $id ? $this->products_model->getProductOptionsWithWH($id) : NULL;
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('add_product')));
            $meta = array('page_title' => lang(''), 'bc' => $bc);
			$this->page_construct('products/add', $meta, $this->data);
        }
    }

    function suggestions()
    {
        $term = $this->input->get('term', TRUE);
        if (strlen($term) < 1 || !$term) {
            die("<script type='text/javascript'>setTimeout(function(){ window.top.location.href = '" . site_url('welcome') . "'; }, 10);</script>");
        }

        $rows = $this->products_model->getProductNames($term);
        if ($rows) {
            $uom = "";
            foreach ($rows as $row) {
                $this->db->select('product_variants.id, product_variants.name');
                $this->db->from('product_variants');
                $this->db->where('product_id', $row->id);
                $q = $this->db->get()->result();
                foreach ($q as $rw) {
                    $uom .= $rw->name . "#";
                }

                $pr[] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")(". $row->unit .")", 'uom' => $uom, 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => 1, 'unit' => $row->unit, 'cost' => $row->cost);
				$uom = '';
            }
            echo json_encode($pr);
        } else {
			echo json_encode(array(array('id' => 0, 'label' => lang('no_match_found'), 'value' => $term)));
        }
    }
	
	public function suggests()
    {
        $term = $this->input->get('term', true);

        if (strlen($term) < 1 || !$term) {
            die("<script type='text/javascript'>setTimeout(function(){ window.top.location.href = '" . site_url('welcome') . "'; }, 10);</script>");
        }
		
        $spos = strpos($term, '%');
        if ($spos !== false) {
            $st = explode("%", $term);
            $sr = trim($st[0]);
            $option = trim($st[1]);
        } else {
            $sr = $term;
            $option = '';
        }

        $rows = $this->products_model->getProductNumber($term);

        if ($rows) {
            $uom = "";
            foreach ($rows as $row) {
                $this->db->select('id, name');
                $this->db->from('product_variants');
                $this->db->where('product_id', $row->id);
                $q = $this->db->get()->result();
                foreach ($q as $rw) {
                    $uom .= $rw->name . "#";
                }

                $pr[] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'uom' => $uom, 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => 1);
            }
            echo json_encode($pr);
        } else {
            echo json_encode(array(array('id' => 0, 'label' => lang('no_match_found'), 'value' => $term)));
        }
    }
	
	function check_product_available($term = NULL){
		$term = $this->input->get('term', TRUE);
        if (strlen($term) < 1 || !$term) {
            die("<script type='text/javascript'>setTimeout(function(){ window.top.location.href = '" . site_url('welcome') . "'; }, 10);</script>");
        }

        $row = $this->products_model->getProductCode($term);
        if ($row) {
            echo 1;
        } else {
            echo 0;
        }
	}

    function get_suggestions()
    {
        $term = $this->input->get('term', TRUE);
        if (strlen($term) < 1 || !$term) {
            die("<script type='text/javascript'>setTimeout(function(){ window.top.location.href = '" . site_url('welcome') . "'; }, 10);</script>");
        }

        $rows = $this->products_model->getProductsForPrinting($term);
        if ($rows) {
            foreach ($rows as $row) {
                $variants = $this->products_model->getProductOptions($row->id);
                $pr[] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => 1, 'variants' => $variants);
            }
            echo json_encode($pr);
        } else {
            echo json_encode(array(array('id' => 0, 'label' => lang('no_match_found'), 'value' => $term)));
        }
    }

    function addByAjax()
    {
        if (!$this->mPermissions('add')) {
            exit(json_encode(array('msg' => lang('access_denied'))));
        }
        if ($this->input->get('token') && $this->input->get('token') == $this->session->userdata('user_csrf') && $this->input->is_ajax_request()) {
            $product = $this->input->get('product');
			if(!isset($product['type']) || empty($prodcut['type'])){
				exit(json_encode(array('msg' => lang('product_type_is_required'))));
			}
            if (!isset($product['code']) || empty($product['code'])) {
                exit(json_encode(array('msg' => lang('product_code_is_required'))));
            }
            if (!isset($product['name']) || empty($product['name'])) {
                exit(json_encode(array('msg' => lang('product_name_is_required'))));
            }
			if (!isset($product['barcode_symbology']) || empty($product['barcode_symbology'])) {
                exit(json_encode(array('msg' => lang('barcode_symbology_is_required'))));
            }
            if (!isset($product['category_id']) || empty($product['category_id'])) {
                exit(json_encode(array('msg' => lang('product_category_is_required'))));
            }
            if (!isset($product['unit']) || empty($product['unit'])) {
                exit(json_encode(array('msg' => lang('product_unit_is_required'))));
            }
            if (!isset($product['price']) || empty($product['price'])) {
                exit(json_encode(array('msg' => lang('product_price_is_required'))));
            }
            if (!isset($product['cost']) || empty($product['cost'])) {
                exit(json_encode(array('msg' => lang('product_cost_is_required'))));
            }
            if ($this->products_model->getProductByCode($product['code'])) {
                exit(json_encode(array('msg' => lang('product_code_already_exist'))));
            }
            if ($row = $this->products_model->addAjaxProduct($product)) {
                $tax_rate = $this->site->getTaxRateByID($row->tax_rate);
                $pr = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'qty' => 1, 'cost' => $row->cost, 'name' => $row->name, 'tax_method' => $row->tax_method, 'tax_rate' => $tax_rate, 'discount' => '0');
                echo json_encode(array('msg' => 'success', 'result' => $pr));
            } else {
                exit(json_encode(array('msg' => lang('failed_to_add_product'))));
            }
        } else {
            json_encode(array('msg' => 'Invalid token'));
        }

    }

    /* -------------------------------------------------------- */

    function edit($id = NULL)
    {
        $this->erp->checkPermissions();
        $this->load->helper('security');
        if ($this->input->post('id')) {
            $id = $this->input->post('id');
        }
        $warehouses = $this->site->getAllWarehouses();
        $warehouses_products = $this->products_model->getAllWarehousesWithPQ($id);
        $product = $this->site->getProductByID($id);
        if (!$id || !$product) {
            $this->session->set_flashdata('error', lang('prduct_not_found'));
            redirect($_SERVER["HTTP_REFERER"]);
        }
        if ($this->input->post('type') == 'standard') {
            // $this->form_validation->set_rules('cost', lang("product_cost"), 'required');
        }
        if ($this->input->post('code') !== $product->code) {
            $this->form_validation->set_rules('code', lang("product_code"), 'is_unique[products.code]');
        }
        if ($this->input->post('barcode_symbology') == 'ean13') {
            $this->form_validation->set_rules('code', lang("product_code"), 'min_length[13]|max_length[13]');
        }
        $this->form_validation->set_rules('product_image', lang("product_image"), 'xss_clean');
        $this->form_validation->set_rules('digital_file', lang("digital_file"), 'xss_clean');
        $this->form_validation->set_rules('userfile', lang("product_gallery_images"), 'xss_clean');

        if ($this->form_validation->run('products/add') == true) {
			if($this->input->post('inactive')) {
				$inactived = $this->input->post('inactive');
			} else {
				$inactived = 0;
			}
            $data = array('code' => $this->input->post('code'),
                'barcode_symbology' => $this->input->post('barcode_symbology'),
                'name' => $this->input->post('name'),
                'type' => $this->input->post('type'),
                'category_id' => $this->input->post('category'),
                'subcategory_id' => $this->input->post('subcategory') ? $this->input->post('subcategory') : NULL,
                'cost' => $this->erp->formatDecimal($this->input->post('cost')),
                'price' => $this->erp->formatDecimal($this->input->post('price')),
                'unit' => $this->input->post('unit'),
                'tax_rate' => $this->input->post('tax_rate'),
                'tax_method' => $this->input->post('tax_method'),
                'alert_quantity' => $this->input->post('alert_quantity'),
                'track_quantity' => $this->input->post('track_quantity') ? $this->input->post('track_quantity') : '0',
                'details' => $this->input->post('details'),
                'product_details' => $this->input->post('product_details'),
                'supplier1' => $this->input->post('supplier'),
                'supplier1price' => $this->erp->formatDecimal($this->input->post('supplier_price')),
                'supplier2' => $this->input->post('supplier_2'),
                'supplier2price' => $this->erp->formatDecimal($this->input->post('supplier_2_price')),
                'supplier3' => $this->input->post('supplier_3'),
                'supplier3price' => $this->erp->formatDecimal($this->input->post('supplier_3_price')),
                'supplier4' => $this->input->post('supplier_4'),
                'supplier4price' => $this->erp->formatDecimal($this->input->post('supplier_4_price')),
                'supplier5' => $this->input->post('supplier_5'),
                'supplier5price' => $this->erp->formatDecimal($this->input->post('supplier_5_price')),
                'cf1' => $this->input->post('cf1'),
                'cf2' => $this->input->post('cf2'),
                'cf3' => $this->input->post('cf3'),
                'cf4' => $this->input->post('cf4'),
                'cf5' => $this->input->post('cf5'),
                'cf6' => $this->input->post('cf6'),
				'promotion' => $this->input->post('promotion'),
                'promo_price' => $this->erp->formatDecimal($this->input->post('promo_price')),
                'start_date' => $this->erp->fsd($this->input->post('start_date')),
                'end_date' => $this->erp->fsd($this->input->post('end_date')),
                'supplier1_part_no' => $this->input->post('supplier_part_no'),
                'supplier2_part_no' => $this->input->post('supplier_2_part_no'),
                'supplier3_part_no' => $this->input->post('supplier_3_part_no'),
                'supplier4_part_no' => $this->input->post('supplier_4_part_no'),
                'supplier5_part_no' => $this->input->post('supplier_5_part_no'), 
				'currentcy_code'    => $this->input->post('currency'),
				'inactived' => $inactived,
				'brand_id'  => $this->input->post('brand')
			);
			//$this->erp->print_arrays($data);
			
			
			$related_straps = $this->input->post('related_strap');
			if($this->site->deleteStrapByProductCode($this->input->post('code'))) {
				for($i=0; $i<sizeof($related_straps); $i++) {
					$product_name = $this->site->getProductByCode($related_straps[$i]);
					$related_products[] = array(
												'product_code' => $this->input->post('code'),
												'related_product_code' => $related_straps[$i],
												'product_name' => $product_name->name,
												);
				}
			}
            $this->load->library('upload');
            if ($this->input->post('type') == 'standard') {
                if ($product_variants = $this->products_model->getProductOptions($id)) {
                    foreach ($product_variants as $pv) {
                        $update_variants[] = array(
                            'id' => $this->input->post('variant_id_'.$pv->id),
                            'name' => $this->input->post('variant_name_'.$pv->id),
							'qty_unit' => $this->input->post('variant_qty_unit_'.$pv->id),
                            //'cost' => $this->input->post('variant_cost_'.$pv->id),
                            'price' => $this->input->post('variant_price_'.$pv->id),
                        );
                    }
                } else {
                    $update_variants = NULL;
                }
                for ($s = 2; $s > 5; $s++) {
                    $data['suppliers' . $s] = $this->input->post('supplier_' . $s);
                    $data['suppliers' . $s . 'price'] = $this->input->post('supplier_' . $s . '_price');
                }
                foreach ($warehouses as $warehouse) {
                    $warehouse_qty[] = array(
                        'warehouse_id' => $this->input->post('wh_' . $warehouse->id),
                        'rack' => $this->input->post('rack_' . $warehouse->id) ? $this->input->post('rack_' . $warehouse->id) : NULL
                    );
                }

                if ($this->input->post('attributes')) {
                    $a = sizeof($_POST['attr_name']);
                    for ($r = 0; $r <= $a; $r++) {
                        if (isset($_POST['attr_name'][$r])) {
                            if ($product_variatnt = $this->products_model->getPrductVariantByPIDandName($id, trim($_POST['attr_name'][$r]))) {
                                $this->form_validation->set_message('required', lang("product_already_has_variant").' ('.$_POST['attr_name'][$r].')');
                                $this->form_validation->set_rules('new_product_variant', lang("new_product_variant"), 'required');
                            } else {
                                $product_attributes[] = array(
                                    'name' => $_POST['attr_name'][$r],
                                    //'warehouse_id' => $_POST['attr_warehouse'][$r],
									'qty_unit' => $_POST['attr_quantity_unit'][$r],
                                    //'quantity' => $_POST['attr_quantity'][$r],
                                    //'cost' => $_POST['attr_cost'][$r],
                                    'price' => $_POST['attr_price'][$r],
                                );
                            }
                        }
                    }

                } else {
                    $product_attributes = NULL;
                }

            } else {
                $warehouse_qty = NULL;
                $product_attributes = NULL;
            }

            if ($this->input->post('type') == 'service') {
                $data['track_quantity'] = 0;
            } elseif ($this->input->post('type') == 'combo') {
                $total_price = 0;
				//$this->erp->print_arrays($_POST['combo_item_quantity_unit']);exit;
                $c = sizeof($_POST['combo_item_code']) - 1;
                for ($r = 0; $r <= $c; $r++) {
                    if (isset($_POST['combo_item_code'][$r]) && isset($_POST['combo_item_quantity_unit'][$r]) && isset($_POST['combo_item_price'][$r])) {
                        $items[] = array(
                            'item_code' => $_POST['combo_item_code'][$r],
							'quantity' => $_POST['combo_item_quantity_unit'][$r],
                            //'quantity' => $_POST['combo_item_quantity'][$r],
                            'unit_price' => $_POST['combo_item_price'][$r],
                        );
                    }
                    $total_price += $_POST['combo_item_price'][$r] * $_POST['combo_item_quantity_unit'][$r];
                }
				//$this->erp->print_arrays($items);
                if ($this->erp->formatDecimal($total_price) != $this->erp->formatDecimal($this->input->post('price'))) {
                    $this->form_validation->set_rules('combo_price', 'combo_price', 'required');
                    $this->form_validation->set_message('required', lang('pprice_not_match_ciprice'));
                }
                $data['track_quantity'] = 0;
            } elseif ($this->input->post('type') == 'digital') {
                if ($_FILES['digital_file']['size'] > 0) {
                    $config['upload_path'] = $this->digital_upload_path;
                    $config['allowed_types'] = $this->digital_file_types;
                    $config['max_size'] = $this->allowed_file_size;
                    $config['overwrite'] = FALSE;
                    $config['encrypt_name'] = TRUE;
                    $config['max_filename'] = 25;
                    $this->upload->initialize($config);
                    if (!$this->upload->do_upload('digital_file')) {
                        $error = $this->upload->display_errors();
                        $this->session->set_flashdata('error', $error);
                        redirect("products/add");
                    }
                    $file = $this->upload->file_name;
                    $data['file'] = $file;
                } else {
                    $this->form_validation->set_rules('digital_file', lang("digital_file"), 'required');
                }
                $config = NULL;
                $data['track_quantity'] = 0;
            }
            if (!isset($items)) {
                $items = NULL;
            }
            if ($_FILES['product_image']['size'] > 0) {

                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                //$config['max_width'] = $this->Settings->iwidth;
                //$config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['encrypt_name'] = TRUE;
                $config['max_filename'] = 25;
                $this->upload->initialize($config);
                if (!$this->upload->do_upload('product_image')) {
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("products/edit/" . $id);
                }
                $photo = $this->upload->file_name;
                $data['image'] = $photo;
                $this->load->library('image_lib');
                $config['image_library'] = 'gd2';
                $config['source_image'] = $this->upload_path . $photo;
                $config['new_image'] = $this->thumbs_path . $photo;
                $config['maintain_ratio'] = TRUE;
                //$config['width'] = $this->Settings->twidth;
                //$config['height'] = $this->Settings->theight;
				$config['width'] = $this->Settings->iwidth;
                $config['height'] = $this->Settings->iheight;
                $this->image_lib->clear();
                $this->image_lib->initialize($config);
				copy($config['new_image'] , $config['source_image']);
                if (!$this->image_lib->resize()) {
                    echo $this->image_lib->display_errors();
                }
                if ($this->Settings->watermark) {
                    $this->image_lib->clear();
                    $wm['source_image'] = $this->upload_path . $photo;
                    $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                    $wm['wm_type'] = 'text';
                    $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                    $wm['quality'] = '100';
                    $wm['wm_font_size'] = '16';
                    $wm['wm_font_color'] = '999999';
                    $wm['wm_shadow_color'] = 'CCCCCC';
                    $wm['wm_vrt_alignment'] = 'top';
                    $wm['wm_hor_alignment'] = 'right';
                    $wm['wm_padding'] = '10';
                    $this->image_lib->initialize($wm);
                    $this->image_lib->watermark();
                }
                $this->image_lib->clear();
                $config = NULL;
            }

            if ($_FILES['userfile']['name'][0] != "") {

                $config['upload_path'] = $this->upload_path;
                $config['allowed_types'] = $this->image_types;
                $config['max_size'] = $this->allowed_file_size;
                //$config['max_width'] = $this->Settings->iwidth;
                //$config['max_height'] = $this->Settings->iheight;
                $config['overwrite'] = FALSE;
                $config['encrypt_name'] = TRUE;
                $config['max_filename'] = 25;
                $files = $_FILES;
                $cpt = count($_FILES['userfile']['name']);
                for ($i = 0; $i < $cpt; $i++) {

                    $_FILES['userfile']['name'] = $files['userfile']['name'][$i];
                    $_FILES['userfile']['type'] = $files['userfile']['type'][$i];
                    $_FILES['userfile']['tmp_name'] = $files['userfile']['tmp_name'][$i];
                    $_FILES['userfile']['error'] = $files['userfile']['error'][$i];
                    $_FILES['userfile']['size'] = $files['userfile']['size'][$i];

                    $this->upload->initialize($config);

                    if (!$this->upload->do_upload()) {
                        $error = $this->upload->display_errors();
                        $this->session->set_flashdata('error', $error);
                        redirect("products/edit/" . $id);
                    } else {

                        $pho = $this->upload->file_name;

                        $photos[] = $pho;

                        $this->load->library('image_lib');
                        $config['image_library'] = 'gd2';
                        $config['source_image'] = $this->upload_path . $pho;
                        $config['new_image'] = $this->thumbs_path . $pho;
                        $config['maintain_ratio'] = TRUE;
                        //$config['width'] = $this->Settings->twidth;
                        //$config['height'] = $this->Settings->theight;
						$config['width'] = $this->Settings->iwidth;
						$config['height'] = $this->Settings->iheight;

                        $this->image_lib->initialize($config);
						copy($config['new_image'] , $config['source_image']);
                        if (!$this->image_lib->resize()) {
                            echo $this->image_lib->display_errors();
                        }

                        if ($this->Settings->watermark) {
                            $this->image_lib->clear();
                            $wm['source_image'] = $this->upload_path . $pho;
                            $wm['wm_text'] = 'Copyright ' . date('Y') . ' - ' . $this->Settings->site_name;
                            $wm['wm_type'] = 'text';
                            $wm['wm_font_path'] = 'system/fonts/texb.ttf';
                            $wm['quality'] = '100';
                            $wm['wm_font_size'] = '16';
                            $wm['wm_font_color'] = '999999';
                            $wm['wm_shadow_color'] = 'CCCCCC';
                            $wm['wm_vrt_alignment'] = 'top';
                            $wm['wm_hor_alignment'] = 'right';
                            $wm['wm_padding'] = '10';
                            $this->image_lib->initialize($wm);
                            $this->image_lib->watermark();
                        }

                        $this->image_lib->clear();
                    }
                }
                $config = NULL;
            } else {
                $photos = NULL;
            }
            $data['quantity'] = isset($wh_total_quantity) ? $wh_total_quantity : 0;
            //echo $this->erp->print_arrays($data, $warehouse_qty, $update_variants, $product_attributes, $photos, $items);
        }

        if ($this->form_validation->run() == true && $this->products_model->updateProduct($id, $data, $items, $warehouse_qty, $product_attributes, $photos, $update_variants, $related_products)) {
            $this->session->set_flashdata('message', lang("product_updated"));
            redirect('products');
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			
			$this->data['currencies'] = $this->products_model->getAllCurrencies();
            $this->data['categories'] = $this->site->getAllCategories();
			$this->data['brands'] = $this->site->getAllBrands();
            $this->data['tax_rates'] = $this->site->getAllTaxRates();
            $this->data['warehouses'] = $warehouses;
            $this->data['warehouses_products'] = $warehouses_products;
            $this->data['product'] = $product;
			$this->data['products'] = $this->site->getAllProducts();
			$this->data['straps'] = $this->products_model->getStrapByProductID($product->code);
            $this->data['variants'] = $this->products_model->getAllVariants();
			
			$this->data['unit'] = $this->products_model->getUnits();
            $this->data['product_variants'] = $this->products_model->getProductOptions($id);
            $this->data['combo_items'] = $product->type == 'combo' ? $this->products_model->getProductComboItems($product->id) : NULL;
            $this->data['product_options'] = $id ? $this->products_model->getProductOptionsWithWH($id) : NULL;
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('edit_product')));
            $meta = array('page_title' => lang('edit_product'), 'bc' => $bc);
            $this->page_construct('products/edit', $meta, $this->data);
        }
    }

    /* ----------------------------------------------------------------------------------------------------------------------------------------- */

    function import_csv()
    {
        //$this->erp->checkPermissions('csv');
		$this->erp->checkPermissions('import', NULL, 'products');	
        $this->load->helper('security');
        $this->form_validation->set_rules('userfile', lang("upload_file"), 'xss_clean');

        if ($this->form_validation->run() == true) {

            if (isset($_FILES["userfile"])) {

                $this->load->library('upload');

                $config['upload_path'] = $this->digital_upload_path;
                $config['allowed_types'] = 'csv';
                $config['max_size'] = $this->allowed_file_size;
                $config['overwrite'] = TRUE;

                $this->upload->initialize($config);

                if (!$this->upload->do_upload()) {

                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("products/import_csv");
                }

                $csv = $this->upload->file_name;

                $arrResult = array();
                $handle = fopen($this->digital_upload_path . $csv, "r");
                if ($handle) {
                    while (($row = fgetcsv($handle, 5000, ",")) !== FALSE) {
                        $arrResult[] = $row;
                    }
                    fclose($handle);
                }
                $titles = array_shift($arrResult);

                $keys = array('code', 'name', 'category_code', 'unit', 'cost', 'price', 'alert_quantity', 'tax_rate', 'tax_method', 'subcategory_code', 'variants','supplier1','supplier2','supplier3', 'supplier4', 'supplier5', 'cf1', 'cf2', 'cf3', 'cf4', 'cf5', 'cf6', 'image');

                $final = array();

                foreach ($arrResult as $key => $value) {
                    $final[] = array_combine($keys, $value);
                } 
                $rw = 2;
				
				$array = array();
				foreach ($final as $csv_pr) {
					$array[] = trim($csv_pr['code']);
				}
				if(count($array) !== count(array_unique($array))){
					$this->session->set_flashdata('error', lang("prodcut_code_is_duplicate"));
                    redirect("products/import_csv");
				}
				
                foreach ($final as $csv_pr) {
                    if ($this->products_model->getProductByCode(trim($csv_pr['code']))) {
                        $this->session->set_flashdata('error', lang("check_product_code") . " (" . $csv_pr['code'] . "). " . lang("code_already_exist") . " " . lang("line_no") . " " . $rw);
                        redirect("products/import_csv");
                    }
					 
                    if ($catd = $this->products_model->getCategoryByCode(trim($csv_pr['category_code']))) {
                        $pr_code[] = trim($csv_pr['code']);
                        $pr_name[] = trim($csv_pr['name']);
                        $pr_cat[] = $catd->id;
                        $pr_variants[] = trim($csv_pr['variants']);
                        $pr_unit[] = trim($csv_pr['unit']);
                        $tax_method[] = $csv_pr['tax_method'] == 'exclusive' ? 1 : 0;
                        $prsubcat = $this->products_model->getSubcategoryByCode(trim($csv_pr['subcategory_code']));
                        $pr_subcat[] = $prsubcat ? $prsubcat->id : NULL;
                        $pr_cost[] = trim($csv_pr['cost']);
                        $pr_price[] = trim($csv_pr['price']);
                        $pr_aq[] = trim($csv_pr['alert_quantity']);
                        $tax_details = $this->products_model->getTaxRateByName(trim($csv_pr['tax_rate']));
                        $pr_tax[] = $tax_details ? $tax_details->id : NULL;
						
						$supplier1[] = trim($csv_pr['supplier1']);
						$supplier2[] = trim($csv_pr['supplier2']);
						$supplier3[] = trim($csv_pr['supplier3']);
						$supplier4[] = trim($csv_pr['supplier4']);
						$supplier5[] = trim($csv_pr['supplier5']);
						
                        $cf1[] = trim($csv_pr['cf1']);
                        $cf2[] = trim($csv_pr['cf2']);
                        $cf3[] = trim($csv_pr['cf3']);
                        $cf4[] = trim($csv_pr['cf4']);
                        $cf5[] = trim($csv_pr['cf5']);
                        $cf6[] = trim($csv_pr['cf6']);
						$image[] = trim($csv_pr['image']);
                    } else {
                        $this->session->set_flashdata('error', lang("check_product_code") . " (" . $csv_pr['code'] . "). " . lang("code_wrong") . " " . lang("line_no") . " " . $rw);
                        redirect("products/import_csv");
                    }
                    $rw++;
                }
            }

            $ikeys = array('code', 'name', 'category_id', 'unit', 'cost', 'price', 'alert_quantity', 'tax_rate', 'tax_method', 'subcategory_id', 'variants', 'supplier1','supplier2','supplier3', 'supplier4', 'supplier5', 'cf1', 'cf2', 'cf3', 'cf4', 'cf5', 'cf6', 'image');

            $items = array();
            foreach (array_map(null, $pr_code, $pr_name, $pr_cat, $pr_unit, $pr_cost, $pr_price, $pr_aq, $pr_tax, $tax_method, $pr_subcat, $pr_variants, $supplier1, $supplier2, $supplier3, $supplier4, $supplier5 ,$cf1, $cf2, $cf3, $cf4, $cf5, $cf6,$image) as $ikey => $value) {
                $items[] = array_combine($ikeys, $value);
            }

            //$this->erp->print_arrays($items);
        }

        if ($this->form_validation->run() == true && $this->products_model->add_products($items)) {
            $this->session->set_flashdata('message', lang("products_added"));
            redirect('products');
        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));

            $this->data['userfile'] = array('name' => 'userfile',
                'id' => 'userfile',
                'type' => 'text',
                'value' => $this->form_validation->set_value('userfile')
            );

            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('import_products_by_csv')));
            $meta = array('page_title' => lang('import_products_by_csv'), 'bc' => $bc);
            $this->page_construct('products/import_csv', $meta, $this->data);

        }
    }

    /* ---------------------------------------------------------------------------------------------- */

    function update_price()
    {
        $this->erp->checkPermissions('csv');
        $this->load->helper('security');
        $this->form_validation->set_rules('userfile', lang("upload_file"), 'xss_clean');

        if ($this->form_validation->run() == true) {

            if (DEMO) {
                $this->session->set_flashdata('message', lang("disabled_in_demo"));
                redirect('welcome');
            }

            if (isset($_FILES["userfile"])) {

                $this->load->library('upload');

                $config['upload_path'] = $this->digital_upload_path;
                $config['allowed_types'] = 'csv';
                $config['max_size'] = $this->allowed_file_size;
                $config['overwrite'] = TRUE;

                $this->upload->initialize($config);

                if (!$this->upload->do_upload()) {

                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("products/update_price");
                }

                $csv = $this->upload->file_name;

                $arrResult = array();
                $handle = fopen($this->digital_upload_path . $csv, "r");
                if ($handle) {
                    while (($row = fgetcsv($handle, 1000, ",")) !== FALSE) {
                        $arrResult[] = $row;
                    }
                    fclose($handle);
                }
                $titles = array_shift($arrResult);

                $keys = array('code', 'price','cost');

                $final = array();

                foreach ($arrResult as $key => $value) {
                    $final[] = array_combine($keys, $value);
                }
                $rw = 2;
                foreach ($final as $csv_pr) {
                    if (!$this->products_model->getProductByCode(trim($csv_pr['code']))) {
                        $this->session->set_flashdata('message', lang("check_product_code") . " (" . $csv_pr['code'] . "). " . lang("code_x_exist") . " " . lang("line_no") . " " . $rw);
                        redirect("products/update_price");
                    }
                    $rw++;
                }
            }

        }

        if ($this->form_validation->run() == true && !empty($final)) {
            $this->products_model->updatePrice($final);
            $this->session->set_flashdata('message', lang("price_updated"));
            redirect('products');
        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));

            $this->data['userfile'] = array('name' => 'userfile',
                'id' => 'userfile',
                'type' => 'text',
                'value' => $this->form_validation->set_value('userfile')
            );

            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('update_price_csv')));
            $meta = array('page_title' => lang('update_price_csv'), 'bc' => $bc);
            $this->page_construct('products/update_price', $meta, $this->data);

        }
    }
	
	function update_quantity()
    {
	
        $this->erp->checkPermissions('csv');
        $this->load->helper('security');
        $this->form_validation->set_rules('userfile', lang("upload_file"), 'xss_clean');

        if ($this->form_validation->run() == true) {
			
            if (DEMO) {
                $this->session->set_flashdata('message', lang("disabled_in_demo"));
                redirect('welcome');
            }

            if (isset($_FILES["userfile"])) {

                $this->load->library('upload');

                $config['upload_path'] = $this->digital_upload_path;
                $config['allowed_types'] = 'csv';
                $config['max_size'] = $this->allowed_file_size;
                $config['overwrite'] = TRUE;

                $hello = $this->upload->initialize($config);
				
                if (!$this->upload->do_upload()) {
					
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect("products/update_quantity");
                }

                $csv = $this->upload->file_name;
				
                $arrResult = array();
                $handle = fopen($this->digital_upload_path . $csv, "r");
				
                if ($handle) {
                    while (($row = fgetcsv($handle, 1000, ",")) !== FALSE) {
                        $arrResult[] = $row;
                    }
                    fclose($handle);
                }
                $titles = array_shift($arrResult);
				
                $keys = array('code', 'quantity', 'opening_stock', 'cost');
				$keys_warehouse = array('quantity', 'warehouse_id');
				$keys_var = array('quantity', 'option_id','warehouse_id');
				$keys_purchase = array('product_code', 'quantity_balance','option_id','warehouse_id','opening_stock');
				
                $final = array();
				$final_ware_product = array();
				$final_var = array();
				$final_purchase_item = array();
				$code_pro = array();
				
				
                foreach ($arrResult as $key => $value) {
					
					$temp_product = $value;
					$temp_warehouse = $value;
					$temp_var = $value;
					
					unset($temp_product[2]);
					unset($temp_product[3]);
					//unset($temp_product[4]);

					unset($temp_warehouse[0]);
					unset($temp_warehouse[2]);
					unset($temp_warehouse[4]);
                    unset($temp_warehouse[5]);
					
					unset($temp_var[0]);
					unset($temp_var[4]);
                    unset($temp_var[5]);
					
					unset($value[5]);
					
					$final[] = array_combine($keys, $temp_product);
					$final_ware_product[] = array_combine($keys_warehouse, $temp_warehouse);
					$final_var[] = array_combine($keys_var, $temp_var);
					$final_purchase_item[] = array_combine($keys_purchase, $value);
					
                    

					$implode[] = implode(',',$value);
					$code_pro[] = array_shift(array_values($value));
                }
           
                $rw = 2;
				$i =0;                

                foreach ($final as $csv_pr) {	
 
					$query_product = $this->products_model->getProductByCode(trim($csv_pr['code']));

					$final_purchase_item[$i]['product_id'] = $query_product->id;
					$final_ware_product[$i]['product_id'] = $query_product->id;
					$final_var[$i]['product_id'] = $query_product->id;					
					$query_product_var = $this->products_model->getOptionId($query_product->id,$final_var[$i]['option_id']);
					
					$final_var[$i]['option_id'] = $query_product_var->id;
					$final_purchase_item[$i]['option_id'] = $query_product_var->id;		
                    $final_purchase_item[$i]['cost'] = $csv_pr['cost'];		
                    if (!$query_product) {
                        $this->session->set_flashdata('message', lang("check_product_code") . " (" . $csv_pr['code'] . "). " . lang("code_x_exist") . " " . lang("line_no") . " " . $rw);
                        redirect("products/update_quantity");
                    }
                    $rw++;
					$i++;
                }
				$total_cost = 0;
				foreach ($final as $csvpr) {
					$cost = $csvpr['quantity'] * $csvpr['cost'];
					$total_cost += $cost;
				}
            }
        }
		
        if ($this->form_validation->run() == true && !empty($final)) {
			//$this->erp->print_arrays($final);
            $this->products_model->updateQuantityExcel($final);
			$this->products_model->updateQuantityExcelWarehouse($final_ware_product);
			$this->products_model->updateQuantityExcelVar($final_var);
			$this->products_model->insertGlTran($total_cost);
			$check  = $this->products_model->updateQuantityExcelPurchase($final_purchase_item);
            if($check)
            {
               $this->session->set_flashdata('message', lang("quantity_updated"));
                redirect('products'); 
            }
            
        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));

            $this->data['userfile'] = array('name' => 'userfile',
                'id' => 'userfile',
                'type' => 'text',
                'value' => $this->form_validation->set_value('userfile')
            );

            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('update_price_csv')));
            $meta = array('page_title' => lang('update_quantity_csv'), 'bc' => $bc);
            $this->page_construct('products/update_quantity', $meta, $this->data);

        }
    }
    
    /* ------------------------------------------------------------------------------- */
	
	/*------------------- */

    function delete($id = NULL)
    {
        $this->erp->checkPermissions(NULL, TRUE);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }

        if ($this->products_model->deleteProduct($id)) {
            if($this->input->is_ajax_request()) {
                echo lang("product_deleted"); die();
            }
            $this->session->set_flashdata('message', lang('product_deleted'));
            redirect('welcome');
        }

    }

    /* ----------------------------------------------------------------------------- */

    function quantity_adjustments()
    {
        $this->erp->checkPermissions('adjustments');

        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');

        $data['warehouses'] = $this->site->getAllWarehouses();

        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('quantity_adjustments')));
        $meta = array('page_title' => lang('quantity_adjustments'), 'bc' => $bc);
        $this->page_construct('products/quantity_adjustments', $meta, $this->data);
    }

    function getadjustments($pdf = NULL, $xls = NULL)
    {
        $this->erp->checkPermissions('adjustments');

        $product = $this->input->get('product') ? $this->input->get('product') : NULL;

        if ($pdf || $xls) {

            $this->db
                ->select($this->db->dbprefix('adjustments') . ".id as did, " . $this->db->dbprefix('adjustments') . ".product_id as productid, " . $this->db->dbprefix('adjustments') . ".date as date, " . $this->db->dbprefix('products') . ".image as image, " . $this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as pname, " . $this->db->dbprefix('product_variants') . ".name as vname, " . $this->db->dbprefix('adjustments') . ".quantity as quantity, ".$this->db->dbprefix('adjustments') . ".type, " . $this->db->dbprefix('warehouses') . ".name as wh");
            $this->db->from('adjustments');
            $this->db->join('products', 'products.id=adjustments.product_id', 'left');
            $this->db->join('product_variants', 'product_variants.id=adjustments.option_id', 'left');
            $this->db->join('warehouses', 'warehouses.id=adjustments.warehouse_id', 'left');
            $this->db->group_by("adjustments.id")->order_by('adjustments.date desc');
            if ($product) {
                $this->db->where('adjustments.product_id', $product);
            }

            $q = $this->db->get();
            if ($q->num_rows() > 0) {
                foreach (($q->result()) as $row) {
                    $data[] = $row;
                }
            } else {
                $data = NULL;
            }

            if (!empty($data)) {

                $this->load->library('excel');
                $this->excel->setActiveSheetIndex(0);
                $this->excel->getActiveSheet()->setTitle(lang('quantity_adjustments'));
                $this->excel->getActiveSheet()->SetCellValue('A1', lang('date'));
                $this->excel->getActiveSheet()->SetCellValue('B1', lang('product_code'));
                $this->excel->getActiveSheet()->SetCellValue('C1', lang('product_name'));
                $this->excel->getActiveSheet()->SetCellValue('D1', lang('product_variant'));
                $this->excel->getActiveSheet()->SetCellValue('E1', lang('quantity'));
                $this->excel->getActiveSheet()->SetCellValue('F1', lang('type'));
                $this->excel->getActiveSheet()->SetCellValue('G1', lang('warehouse'));

                $row = 2;
                foreach ($data as $data_row) {
                    $this->excel->getActiveSheet()->SetCellValue('A' . $row, $this->erp->hrld($data_row->date));
                    $this->excel->getActiveSheet()->SetCellValue('B' . $row, $data_row->code);
                    $this->excel->getActiveSheet()->SetCellValue('C' . $row, $data_row->pname);
                    $this->excel->getActiveSheet()->SetCellValue('D' . $row, $data_row->vname);
                    $this->excel->getActiveSheet()->SetCellValue('E' . $row, $data_row->quantity);
                    $this->excel->getActiveSheet()->SetCellValue('F' . $row, lang($data_row->type));
                    $this->excel->getActiveSheet()->SetCellValue('G' . $row, $data_row->wh);
                    $row++;
                }

                $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
                $filename = lang('quantity_adjustments');
                $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                if ($pdf) {
                    $styleArray = array(
                        'borders' => array(
                            'allborders' => array(
                                'style' => PHPExcel_Style_Border::BORDER_THIN
                            )
                        )
                    );
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
                    $objWriter->save('php://output');
                    exit();
                }
                if ($xls) {
                    ob_clean();
                    header('Content-Type: application/vnd.ms-excel');
                    header('Content-Disposition: attachment;filename="' . $filename . '.xls"');
                    header('Cache-Control: max-age=0');
                    ob_clean();
                    $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'Excel5');
                    $objWriter->save('php://output');
                    exit();
                }

            }

            $this->session->set_flashdata('error', lang('nothing_found'));
            redirect($_SERVER["HTTP_REFERER"]);

        } else {

            $delete_link = "<a href='#' class='tip po' title='<b>" . $this->lang->line("delete_adjustment") . "</b>' data-content=\"<p>"
                . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' id='a__$1' href='" . site_url('products/delete_adjustment/$2') . "'>"
                . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i></a>";

            $this->load->library('datatables');
            $this->datatables
                ->select($this->db->dbprefix('adjustments') . ".id as did, " . $this->db->dbprefix('adjustments') . ".product_id as productid, " . $this->db->dbprefix('adjustments') . ".date as date, " . $this->db->dbprefix('products') . ".image as image, " . $this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as pname, " . $this->db->dbprefix('product_variants') . ".name as vname, " . $this->db->dbprefix('adjustments') . ".quantity as quantity, ".$this->db->dbprefix('adjustments') . ".type, " . $this->db->dbprefix('warehouses') . ".name as wh");
            $this->datatables->from('adjustments');
            $this->datatables->join('products', 'products.id=adjustments.product_id', 'left');
            $this->datatables->join('product_variants', 'product_variants.id=adjustments.option_id', 'left');
            $this->datatables->join('warehouses', 'warehouses.id=adjustments.warehouse_id', 'left');
            $this->datatables->group_by("adjustments.id");
            $this->datatables->add_column("Actions", "<div class='text-center'><a href='" . site_url('products/edit_adjustment/$1/$2') . "' class='tip' title='" . lang("edit_adjustment") . "' data-toggle='modal' data-target='#myModal'><i class='fa fa-edit'></i></a> " . $delete_link . "</div>", "productid, did");
            if ($product) {
                $this->datatables->where('adjustments.product_id', $product);
            }
            $this->datatables->unset_column('did');
            $this->datatables->unset_column('productid');
            $this->datatables->unset_column('image');

            echo $this->datatables->generate();

        }

    }
	
	//-------------- Export to Excel and PDF product
	function getProductAll($pdf = NULL, $excel = NULL)
    {
        $this->erp->checkPermissions('products');

        $product = $this->input->get('product') ? $this->input->get('product') : NULL;

        if ($pdf || $excel) {

            $this->db
                ->select($this->db->dbprefix('products') . ".code as codes, " . $this->db->dbprefix('products') . ".name as names,". $this->db->dbprefix('products') .".unit as units,
				" . $this->db->dbprefix('categories') . ".name as cname, " . $this->db->dbprefix('products') . ".cost as costes, 
				" . $this->db->dbprefix('products') . ".price as prices, " . $this->db->dbprefix('products') . ".quantity as quantities,
				" . $this->db->dbprefix('products') . ".alert_quantity as alert_quantities,
				" . $this->db->dbprefix('warehouses') . ".name as wname");
            $this->db->from('products');
            $this->db->join('categories', 'categories.id=products.category_id', 'left');
            $this->db->join('warehouses', 'warehouses.id=products.warehouse', 'left');
            $this->db->group_by("products.id")->order_by('products.id desc');
            if ($product) {
                $this->db->where('product.id', $product);
            }

            $q = $this->db->get();
            if ($q->num_rows() > 0) {
                foreach (($q->result()) as $row) {
                    $data[] = $row;
                }
            } else {
                $data = NULL;
            }

            if (!empty($data)) {

                $this->load->library('excel');
                $this->excel->setActiveSheetIndex(0);
                $this->excel->getActiveSheet()->setTitle(lang('products'));
				$this->excel->getActiveSheet()->SetCellValue('A1', lang('product_code'));
                $this->excel->getActiveSheet()->SetCellValue('B1', lang('product_name'));
                $this->excel->getActiveSheet()->SetCellValue('C1', lang('category'));
                $this->excel->getActiveSheet()->SetCellValue('D1', lang('product_cost'));
                $this->excel->getActiveSheet()->SetCellValue('E1', lang('product_price'));
                $this->excel->getActiveSheet()->SetCellValue('F1', lang('quantity'));
                $this->excel->getActiveSheet()->SetCellValue('G1', lang('product_unit'));
                $this->excel->getActiveSheet()->SetCellValue('H1', lang('alert_quantity'));

                $row = 2;
                foreach ($data as $data_row) {
                    //$this->excel->getActiveSheet()->SetCellValue('A' . $row, $this->erp->hrld($data_row->id));
                    $this->excel->getActiveSheet()->SetCellValue('A' . $row, $data_row->codes);
					$this->excel->getActiveSheet()->SetCellValue('B' . $row, $data_row->names);
                    $this->excel->getActiveSheet()->SetCellValue('C' . $row, $data_row->cname);
                    $this->excel->getActiveSheet()->SetCellValue('D' . $row, $data_row->costes);
                    $this->excel->getActiveSheet()->SetCellValue('E' . $row, $data_row->prices);
                    $this->excel->getActiveSheet()->SetCellValue('F' . $row, lang($data_row->quantities));
					$this->excel->getActiveSheet()->SetCellValue('G' . $row, lang($data_row->units));
					$this->excel->getActiveSheet()->SetCellValue('H' . $row, lang($data_row->alert_quantities));
                    //$this->excel->getActiveSheet()->SetCellValue('G' . $row, $data_row->wh);
                    $row++;
                }

                $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
				$this->excel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
                $filename = 'Product_' . date('Y_m_d_H_i_s');
                $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                if ($pdf) {
                    $styleArray = array(
                        'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN))
                    );
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
                    $objWriter->save('php://output');
                    exit();
                }
                if ($excel) {
                    ob_clean();
                    header('Content-Type: application/vnd.ms-excel');
                    header('Content-Disposition: attachment;filename="' . $filename . '.xls"');
                    header('Cache-Control: max-age=0');
                    ob_clean();
                    $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'Excel5');
                    $objWriter->save('php://output');
                    exit();
                }

            }

            $this->session->set_flashdata('error', lang('nothing_found'));
            redirect($_SERVER["HTTP_REFERER"]);

        }
    }
	//------------------- End export product

    function add_adjustment($product_id = NULL, $warehouse_id = NULL)
    {
        $this->erp->checkPermissions('adjustments', true);

        $this->form_validation->set_rules('type', lang("type"), 'required');
        $this->form_validation->set_rules('quantity', lang("quantity"), 'required');
        $this->form_validation->set_rules('warehouse', lang("warehouse"), 'required');

        if ($this->form_validation->run() == true) {

            if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld($this->input->post('date'));
            } else {
                $date = date('Y-m-d H:s:i');
            }
			
            $data = array(
                'date' => $date,
                'product_id' => $product_id,
                'type' => $this->input->post('type'),
                'quantity' => $this->input->post('quantity'),
                'warehouse_id' => $this->input->post('warehouse'),
                'option_id' => $this->input->post('option') ? $this->input->post('option') : NULL,
                'note' => $this->erp->clear_tags($this->input->post('note')),
                'created_by' => $this->session->userdata('user_id'),
				'biller_id' => $this->default_biller_id?$this->default_biller_id:''
            );
			
            if (!$this->Settings->overselling && $this->input->post('type') == 'subtraction') {
                if ($this->input->post('option')) {
                    if($op_wh_qty = $this->products_model->getProductWarehouseOptionQty($this->input->post('option'), $this->input->post('warehouse'))) {
                        if ($op_wh_qty->quantity < $data['quantity']) {
                            $this->session->set_flashdata('error', lang('warehouse_option_qty_is_less_than_damage'));
                            redirect($_SERVER["HTTP_REFERER"]);
                        }
                    } else {
                        $this->session->set_flashdata('error', lang('warehouse_option_qty_is_less_than_damage'));
                        redirect($_SERVER["HTTP_REFERER"]);
                    }
                }
                if($wh_qty = $this->products_model->getProductQuantity($product_id, $this->input->post('warehouse'))) {
                    if ($wh_qty['quantity'] < $data['quantity']) {
                        $this->session->set_flashdata('error', lang('warehouse_qty_is_less_than_damage'));
                        redirect($_SERVER["HTTP_REFERER"]);
                    }
                } else {
                    $this->session->set_flashdata('error', lang('warehouse_qty_is_less_than_damage'));
                    redirect($_SERVER["HTTP_REFERER"]);
                }
            }
			

        } elseif ($this->input->post('adjust_quantity')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect('products');
        }

        if ($this->form_validation->run() == true && $this->products_model->addAdjustment($data)) {
            $this->session->set_flashdata('message', lang("quantity_adjusted"));
            redirect('products/quantity_adjustments');
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $product = $this->site->getProductByID($product_id);
            if($product->type != 'standard') {
                $this->session->set_flashdata('error', lang('quantity_x_adjuste').' ('.lang('product_type').': '.lang($product->type).')');
                die('<script>window.location.replace("'.$_SERVER["HTTP_REFERER"].'");</script>');
            }
            $this->data['product'] = $product;
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['modal_js'] = $this->site->modal_js();
            $this->data['options'] = $this->products_model->getProductOptions($product_id);
            $this->data['product_id'] = $product_id;
            $this->data['warehouse_id'] = $warehouse_id;
            $this->load->view($this->theme . 'products/add_adjustment', $this->data);

        }
    }

    function edit_adjustment($product_id = NULL, $id = NULL)
    {
        $this->erp->checkPermissions('adjustments', true);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }
        if ($this->input->get('product_id')) {
            $product_id = $this->input->get('product_id');
        }
        $this->form_validation->set_rules('type', lang("type"), 'required');
        $this->form_validation->set_rules('quantity', lang("quantity"), 'required');
        $this->form_validation->set_rules('warehouse', lang("warehouse"), 'required');

        if ($this->form_validation->run() == true) {

            if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld($this->input->post('date'));
            } else {
                $date = NULL;
            }

            $data = array(
                'product_id' => $product_id,
                'type' => $this->input->post('type'),
                'quantity' => $this->input->post('quantity'),
                'warehouse_id' => $this->input->post('warehouse'),
                'option_id' => $this->input->post('option') ? $this->input->post('option') : NULL,
                'note' => $this->erp->clear_tags($this->input->post('note')),
                'updated_by' => $this->session->userdata('user_id')
                );
            if ($date) {
                $data['date'] = $date;
            }

            if (!$this->Settings->overselling && $this->input->post('type') == 'subtraction') {
                $dp_details = $this->products_model->getAdjustmentByID($id);
                if ($this->input->post('option')) {
                    $op_wh_qty = $this->products_model->getProductWarehouseOptionQty($this->input->post('option'), $this->input->post('warehouse'));
                    $old_op_qty = $op_wh_qty->quantity + $dp_details->quantity;
                    if ($old_op_qty < $data['quantity']) {
                        $this->session->set_flashdata('error', lang('warehouse_option_qty_is_less_than_damage'));
                        redirect('products');
                    }
                }
                $wh_qty = $this->products_model->getProductQuantity($product_id, $this->input->post('warehouse'));
                $old_quantity = $wh_qty['quantity'] + $dp_details->quantity;
                if ($old_quantity < $data['quantity']) {
                    $this->session->set_flashdata('error', lang('warehouse_qty_is_less_than_damage'));
                    redirect('products/quantity_adjustments');
                }
            }

        } elseif ($this->input->post('edit_adjustment')) {
            $this->session->set_flashdata('error', validation_errors());
            redirect('products/quantity_adjustments');
        }

        if ($this->form_validation->run() == true && $this->products_model->updateAdjustment($id, $data)) {
            $this->session->set_flashdata('message', lang("quantity_adjusted"));
            redirect('products/quantity_adjustments');
        } else {
            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));

            $this->data['product'] = $this->site->getProductByID($product_id);
            $this->data['options'] = $this->products_model->getProductOptions($product_id);
            $this->data['damage'] = $this->products_model->getAdjustmentByID($id);
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['id'] = $id;
            $this->data['product_id'] = $product_id;
            $this->data['modal_js'] = $this->site->modal_js();
            $this->load->view($this->theme . 'products/edit_adjustment', $this->data);
        }
    }

    function delete_adjustment($id = NULL)
    {
        $this->erp->checkPermissions(NULL, TRUE);

        if ($this->products_model->deleteAdjustment($id)) {
            echo lang("adjustment_deleted");
        }

    }

    /* --------------------------------------------------------------------------------------------- */

    function modal_view($id = NULL)
    {
        $this->erp->checkPermissions('index', TRUE);

        $pr_details = $this->site->getProductByID($id);
        if (!$id || !$pr_details) {
            $this->session->set_flashdata('error', lang('prduct_not_found'));
            redirect($_SERVER["HTTP_REFERER"]);
        }
        $this->data['barcode'] = "<img src='" . site_url('products/gen_barcode/' . $pr_details->code . '/' . $pr_details->barcode_symbology . '/40/0') . "' alt='" . $pr_details->code . "' class='pull-left' />";
        if ($pr_details->type == 'combo') {
            $this->data['combo_items'] = $this->products_model->getProductComboItems($id);
        }
        $this->db->select('*');
        $this->db->from('companies');
        $this->db->where('id',  $pr_details->supplier1);
        $q = $this->db->get()->result();

        $this->data['supplier'] = $q;
        $this->data['product'] = $pr_details;
        $this->data['images'] = $this->products_model->getProductPhotos($id);
        $this->data['category'] = $this->site->getCategoryByID($pr_details->category_id);
        $this->data['subcategory'] = $pr_details->subcategory_id ? $this->products_model->getSubCategoryByID($pr_details->subcategory_id) : NULL;
        $this->data['tax_rate'] = $pr_details->tax_rate ? $this->site->getTaxRateByID($pr_details->tax_rate) : NULL;
        $this->data['warehouses'] = $this->products_model->getAllWarehousesWithPQ($id);
        $this->data['options'] = $this->products_model->getProductOptionsWithWH($id);
        $this->data['variants'] = $this->products_model->getProductOptions($id);

        $this->load->view($this->theme.'products/modal_view', $this->data);
    }

    function view($id = NULL)
    {
        $this->erp->checkPermissions('index');

        $pr_details = $this->products_model->getProductByID($id);
        if (!$id || !$pr_details) {
            $this->session->set_flashdata('error', lang('prduct_not_found'));
            redirect($_SERVER["HTTP_REFERER"]);
        }
        $this->data['barcode'] = "<img src='" . site_url('products/gen_barcode/' . $pr_details->code . '/' . $pr_details->barcode_symbology . '/40/0') . "' alt='" . $pr_details->code . "' class='pull-left' />";
        if ($pr_details->type == 'combo') {
            $this->data['combo_items'] = $this->products_model->getProductComboItems($id);
        }
        $this->data['product'] = $pr_details;
        $this->data['images'] = $this->products_model->getProductPhotos($id);
        $this->data['category'] = $this->site->getCategoryByID($pr_details->category_id);
        $this->data['subcategory'] = $pr_details->subcategory_id ? $this->products_model->getSubCategoryByID($pr_details->subcategory_id) : NULL;
        $this->data['tax_rate'] = $pr_details->tax_rate ? $this->site->getTaxRateByID($pr_details->tax_rate) : NULL;
        $this->data['popup_attributes'] = $this->popup_attributes;
        $this->data['warehouses'] = $this->products_model->getAllWarehousesWithPQ($id);
        $this->data['options'] = $this->products_model->getProductOptionsWithWH($id);
        $this->data['variants'] = $this->products_model->getProductOptions($id);
        $this->data['sold'] = $this->products_model->getSoldQty($id);
        $this->data['purchased'] = $this->products_model->getPurchasedQty($id);

        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => $pr_details->name));
        $meta = array('page_title' => $pr_details->name, 'bc' => $bc);
        $this->page_construct('products/view', $meta, $this->data);
    }

    function pdf($id = NULL, $view = NULL)
    {
        $this->erp->checkPermissions('index');

        $pr_details = $this->products_model->getProductByID($id);
        if (!$id || !$pr_details) {
            $this->session->set_flashdata('error', lang('prduct_not_found'));
            redirect($_SERVER["HTTP_REFERER"]);
        }
        $this->data['barcode'] = "<img src='" . site_url('products/gen_barcode/' . $pr_details->code . '/' . $pr_details->barcode_symbology . '/40/0') . "' alt='" . $pr_details->code . "' class='pull-left' />";
        if ($pr_details->type == 'combo') {
            $this->data['combo_items'] = $this->products_model->getProductComboItems($id);
        }
        $this->data['product'] = $pr_details;
        $this->data['images'] = $this->products_model->getProductPhotos($id);
        $this->data['category'] = $this->site->getCategoryByID($pr_details->category_id);
        $this->data['subcategory'] = $pr_details->subcategory_id ? $this->products_model->getSubCategoryByID($pr_details->subcategory_id) : NULL;
        $this->data['tax_rate'] = $pr_details->tax_rate ? $this->site->getTaxRateByID($pr_details->tax_rate) : NULL;
        $this->data['popup_attributes'] = $this->popup_attributes;
        $this->data['warehouses'] = $this->products_model->getAllWarehousesWithPQ($id);
        $this->data['options'] = $this->products_model->getProductOptionsWithWH($id);
        $this->data['variants'] = $this->products_model->getProductOptions($id);

        $name = $pr_details->code . '_' . str_replace('/', '_', $pr_details->name) . ".pdf";
        if ($view) {
            $this->load->view($this->theme . 'products/pdf', $this->data);
        } else {
            $html = $this->load->view($this->theme . 'products/pdf', $this->data, TRUE);
            $this->erp->generate_pdf($html, $name);
        }
    }
	
	function getCategories($band_id = NULL)
    {
        if ($rows = $this->products_model->getCategoriesForBrandID($band_id)) {
            $data = json_encode($rows);
        } else {
            $data = false;
        }
        echo $data;
    }

    function getSubCategories($category_id = NULL)
    {
        if ($rows = $this->products_model->getSubCategoriesForCategoryID($category_id)) {
            $data = json_encode($rows);
        } else {
            $data = false;
        }
        echo $data;
    }

    /*function product_actions($wh = NULL)
    {
        if (!$this->Owner) {
            $this->session->set_flashdata('warning', lang('access_denied'));
            redirect($_SERVER["HTTP_REFERER"]);
        }

        $this->form_validation->set_rules('form_action', lang("form_action"), 'required');

        if ($this->form_validation->run() == true) {

            if (!empty($_POST['val'])) {
                if ($this->input->post('form_action') == 'sync_quantity') {
					
                    foreach ($_POST['val'] as $id) {
                        $this->site->syncQuantity(NULL, NULL, NULL, $id);
                    }
                    $this->session->set_flashdata('message', $this->lang->line("products_quantity_sync"));
                    redirect($_SERVER["HTTP_REFERER"]);
				
                }else if ($this->input->post('form_action') == 'delete') {
                    foreach ($_POST['val'] as $id) {
                        $this->products_model->deleteProduct($id);
                    }
                    $this->session->set_flashdata('message', $this->lang->line("products_deleted"));
                    redirect($_SERVER["HTTP_REFERER"]);
					
                }else if ($this->input->post('form_action') == 'labels') {
                    $currencies = $this->site->getAllCurrencies();
                    $r = 1;
                    $inputs = '';
                    $html = "";
                    $html .= '<table class="table table-bordered table-condensed bartable"><tbody><tr>';
                    foreach ($_POST['val'] as $id) {
                        $inputs .= form_hidden('val[]', $id);
                        $pr = $this->products_model->getProductByID($id);

                        $html .= '<td class="text-center"><h4>' . $this->Settings->site_name . '</h4>' . $pr->name . '<br>' . $this->product_barcode($pr->code, $pr->barcode_symbology, 30);
                        $html .= '<table class="table table-bordered">';
                        foreach ($currencies as $currency) {
                            $html .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($pr->price * $currency->rate) . '</td></tr>';
                        }
                        $html .= '</table>';
                        $html .= '</td>';

                        if ($r % 4 == 0) {
                            $html .= '</tr><tr>';
                        }
                        $r++;
                    }
                    if ($r < 4) {
                        for ($i = $r; $i <= 4; $i++) {
                            $html .= '<td></td>';
                        }
                    }
                    $html .= '</tr></tbody></table>';

                    $this->data['r'] = $r;
                    $this->data['html'] = $html;
                    $this->data['inputs'] = $inputs;
                    $this->data['page_title'] = lang("print_labels");
                    $this->data['categories'] = $this->site->getAllCategories();
                    $this->data['category_id'] = '';
                    //$this->load->view($this->theme . 'products/print_labels', $this->data);
                    $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_labels')));
                    $meta = array('page_title' => lang('print_labels'), 'bc' => $bc);
                    $this->page_construct('products/print_labels', $meta, $this->data);
                }else if ($this->input->post('form_action') == 'barcodes') {
                    $currencies = $this->site->getAllCurrencies();
                    $r = 1;

                    $html = "";
                    $html .= '<table class="table table-bordered sheettable"><tbody><tr>';
                    foreach ($_POST['val'] as $id) {
                        $pr = $this->site->getProductByID($id);
                        if ($r != 1) {
                            $rw = (bool)($r & 1);
                            $html .= $rw ? '</tr><tr>' : '';
                        }
                        $html .= '<td colspan="2" class="text-center"><h3>' . $this->Settings->site_name . '</h3>' . $pr->name . '<br>' . $this->product_barcode($pr->code, $pr->barcode_symbology, 60);
                        $html .= '<table class="table table-bordered">';
                        foreach ($currencies as $currency) {
                            $html .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($pr->price * $currency->rate) . '</td></tr>';
                        }
                        $html .= '</table>';
                        $html .= '</td>';
                        $r++;
                    }
                    if (!(bool)($r & 1)) {
                        $html .= '<td></td>';
                    }
                    $html .= '</tr></tbody></table>';

                    $this->data['r'] = $r;
                    $this->data['html'] = $html;
                    $this->data['category_id'] = '';
                    $this->data['categories'] = $this->site->getAllCategories();
                    $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_barcodes')));
                    $meta = array('page_title' => lang('print_barcodes'), 'bc' => $bc);
                    $this->page_construct('products/print_barcodes', $meta, $this->data);
                    //$this->load->view($this->theme . 'products/print_barcodes', $this->data);
                }else if ($this->input->post('form_action') == 'export_excel' || $this->input->post('form_action') == 'export_pdf') {

                    $this->load->library('excel');
                    $this->excel->setActiveSheetIndex(0);
                    $this->excel->getActiveSheet()->setTitle('Products');
                    $this->excel->getActiveSheet()->SetCellValue('A1', lang('product_code'));
                    $this->excel->getActiveSheet()->SetCellValue('B1', lang('product_name'));
                    $this->excel->getActiveSheet()->SetCellValue('C1', lang('category_code'));
                    $this->excel->getActiveSheet()->SetCellValue('D1', lang('unit'));
                    $this->excel->getActiveSheet()->SetCellValue('E1', lang('cost'));
                    $this->excel->getActiveSheet()->SetCellValue('F1', lang('price'));
                    $this->excel->getActiveSheet()->SetCellValue('G1', lang('quantity'));
                    $this->excel->getActiveSheet()->SetCellValue('H1', lang('alert_quantity'));
                    $this->excel->getActiveSheet()->SetCellValue('I1', lang('tax_rate'));
                    $this->excel->getActiveSheet()->SetCellValue('J1', lang('tax_method'));
                    $this->excel->getActiveSheet()->SetCellValue('K1', lang('subcategory_code'));
                    $this->excel->getActiveSheet()->SetCellValue('L1', lang('product_variants'));
                    $this->excel->getActiveSheet()->SetCellValue('M1', lang('pcf1'));
                    $this->excel->getActiveSheet()->SetCellValue('N1', lang('pcf2'));
                    $this->excel->getActiveSheet()->SetCellValue('O1', lang('pcf3'));
                    $this->excel->getActiveSheet()->SetCellValue('P1', lang('pcf4'));
                    $this->excel->getActiveSheet()->SetCellValue('Q1', lang('pcf5'));
                    $this->excel->getActiveSheet()->SetCellValue('R1', lang('pcf6'));

                    $row = 2;
                    foreach ($_POST['val'] as $id) {
                        $product = $this->products_model->getProductDetail($id);
                        $variants = $this->products_model->getProductOptions($id);
                        $product_variants = '';
                        if ($variants) {
                            foreach ($variants as $variant) {
                                $product_variants .= trim($variant->name) . '|';
                            }
                        }
                        $quantity = $product->quantity;
                        if ($wh) {
                            if($wh_qty = $this->products_model->getProductQuantity($id, $wh)) {
                                $quantity = $wh_qty['quantity'];
                            } else {
                                $quantity = 0;
                            }
                        }
                        $this->excel->getActiveSheet()->SetCellValue('A' . $row, $product->code);
                        $this->excel->getActiveSheet()->SetCellValue('B' . $row, $product->name);
                        $this->excel->getActiveSheet()->SetCellValue('C' . $row, $product->category_code);
                        $this->excel->getActiveSheet()->SetCellValue('D' . $row, $product->unit);
                        $this->excel->getActiveSheet()->SetCellValue('E' . $row, $product->cost);
                        $this->excel->getActiveSheet()->SetCellValue('F' . $row, $product->price);
                        $this->excel->getActiveSheet()->SetCellValue('G' . $row, $quantity);
                        $this->excel->getActiveSheet()->SetCellValue('H' . $row, $product->alert_quantity);
                        $this->excel->getActiveSheet()->SetCellValue('I' . $row, $product->tax_rate_code);
                        $this->excel->getActiveSheet()->SetCellValue('J' . $row, $product->tax_method ? lang('exclusive') : lang('inclusive'));
                        $this->excel->getActiveSheet()->SetCellValue('K' . $row, $product->subcategory_code);
                        $this->excel->getActiveSheet()->SetCellValue('L' . $row, $product_variants);
                        $this->excel->getActiveSheet()->SetCellValue('M' . $row, $product->cf1);
                        $this->excel->getActiveSheet()->SetCellValue('N' . $row, $product->cf2);
                        $this->excel->getActiveSheet()->SetCellValue('O' . $row, $product->cf3);
                        $this->excel->getActiveSheet()->SetCellValue('P' . $row, $product->cf4);
                        $this->excel->getActiveSheet()->SetCellValue('Q' . $row, $product->cf5);
                        $this->excel->getActiveSheet()->SetCellValue('R' . $row, $product->cf6);
                        $row++;
                    }

                    $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(30);
                    $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
                    $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                    $filename = 'products_' . date('Y_m_d_H_i_s');
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
                $this->session->set_flashdata('error', $this->lang->line("no_product_selected"));
                redirect($_SERVER["HTTP_REFERER"]);
            }
        } else {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER["HTTP_REFERER"]);
        }
    }*/
    
function product_actions($wh = NULL)
    {
        if (!$this->Owner) {
            $this->session->set_flashdata('warning', lang('access_denied'));
            redirect($_SERVER["HTTP_REFERER"]);
        }

        $this->form_validation->set_rules('form_action', lang("form_action"), 'required');

        if ($this->form_validation->run() == true) {

            if (!empty($_POST['val'])) {
                if ($this->input->post('form_action') == 'sync_quantity') {
                    
                    foreach ($_POST['val'] as $id) {
                        $this->site->syncQuantity(NULL, NULL, NULL, $id);
                    }
                    $this->session->set_flashdata('message', $this->lang->line("products_quantity_sync"));
                    redirect($_SERVER["HTTP_REFERER"]);
                
                }else if ($this->input->post('form_action') == 'delete') {
                    foreach ($_POST['val'] as $id) {
                        $this->products_model->deleteProduct($id);
                    }
                    $this->session->set_flashdata('message', $this->lang->line("products_deleted"));
                    redirect($_SERVER["HTTP_REFERER"]);
                    
                }else if ($this->input->post('form_action') == 'labels') {
                    $currencies = $this->site->getAllCurrencies();
                    $r = 1;
                    $inputs = '';
                    $html = "";
                    $html .= '<table class="table table-bordered table-condensed bartable"><tbody><tr>';
                    foreach ($_POST['val'] as $id) {
                        $inputs .= form_hidden('val[]', $id);
                        $pr = $this->products_model->getProductByID($id);

                        $html .= '<td class="text-center"><h4>' . $this->Settings->site_name . '</h4>' . $pr->name . '<br>' . $this->product_barcode($pr->code, $pr->barcode_symbology, 30);
                        $html .= '<table class="table table-bordered">';
                        foreach ($currencies as $currency) {
                            $html .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($pr->price * $currency->rate) . '</td></tr>';
                        }
                        $html .= '</table>';
                        $html .= '</td>';

                        if ($r % 4 == 0) {
                            $html .= '</tr><tr>';
                        }
                        $r++;
                    }
                    if ($r < 4) {
                        for ($i = $r; $i <= 4; $i++) {
                            $html .= '<td></td>';
                        }
                    }
                    $html .= '</tr></tbody></table>';

                    $this->data['r'] = $r;
                    $this->data['html'] = $html;
                    $this->data['inputs'] = $inputs;
                    $this->data['page_title'] = lang("print_labels");
                    $this->data['categories'] = $this->site->getAllCategories();
                    $this->data['category_id'] = '';
                    //$this->load->view($this->theme . 'products/print_labels', $this->data);
                    $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_labels')));
                    $meta = array('page_title' => lang('print_labels'), 'bc' => $bc);
                    $this->page_construct('products/print_labels', $meta, $this->data);
                }else if ($this->input->post('form_action') == 'barcodes') {
					foreach ($_POST['val'] as $id) {
                        $row = $this->products_model->getProductByID($id);
                        $selected_variants = false;
                        if ($variants = $this->products_model->getProductOptions($row->id)) {
                            foreach ($variants as $variant) {
                                $selected_variants[$variant->id] = $variant->quantity > 0 ? 1 : 0;
                            }
                        }
                        $pr[$row->id] = array('id' => $row->id, 'label' => $row->name . " (" . $row->code . ")", 'code' => $row->code, 'name' => $row->name, 'price' => $row->price, 'qty' => $row->quantity, 'variants' => $variants, 'selected_variants' => $selected_variants);
                    }

                    $this->data['items'] = isset($pr) ? json_encode($pr) : false;
                    $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
                    $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_barcodes')));
                    $meta = array('page_title' => lang('print_barcodes'), 'bc' => $bc);
                    $this->page_construct('products/print_barcodes', $meta, $this->data);
					
					/*
                    $currencies = $this->site->getAllCurrencies();
                    $r = 1;

                    $html = "";
                    $html .= '<table class="table table-bordered sheettable"><tbody><tr>';
                    foreach ($_POST['val'] as $id) {
                        $pr = $this->site->getProductByID($id);
			//			echo $pr->id;
                        if ($r != 1) {
                            $rw = (bool)($r & 1);
                            $html .= $rw ? '</tr><tr>' : '';
                        }
                        $html .= '<td colspan="2" class="text-center"><h3>' . $this->Settings->site_name . '</h3>' . $pr->name . '<br>' . $this->product_barcode($pr->code, $pr->barcode_symbology, 60);
                        $html .= '<table class="table table-bordered">';
                        foreach ($currencies as $currency) {
                            $html .= '<tr><td class="text-left">' . $currency->code . '</td><td class="text-right">' . $this->erp->formatMoney($pr->price * $currency->rate) . '</td></tr>';
                        }
                        $html .= '</table>';
                        $html .= '</td>';
                        $r++;
                    }
                    if (!(bool)($r & 1)) {
                        $html .= '<td></td>';
                    }
                    $html .= '</tr></tbody></table>';
					
                    $this->data['r'] = $r;
                    $this->data['html'] = $html;
				
                    $this->data['category_id'] = '';
                    $this->data['categories'] = $this->site->getAllCategories();
                    $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('print_barcodes')));
                    $meta = array('page_title' => lang('print_barcodes'), 'bc' => $bc);
                    $this->page_construct('products/print_barcodes', $meta, $this->data);
                    //$this->load->view($this->theme . 'products/print_barcodes', $this->data);*/
                }else if ($this->input->post('form_action') == 'export_excel' || $this->input->post('form_action') == 'export_pdf') {

                    $this->load->library('excel');
                    $this->excel->setActiveSheetIndex(0);
                    $this->excel->getActiveSheet()->setTitle('Products');
                    $this->excel->getActiveSheet()->SetCellValue('A1', lang('product_code'));
                    $this->excel->getActiveSheet()->SetCellValue('B1', lang('product_name'));
                    $this->excel->getActiveSheet()->SetCellValue('C1', lang('category'));
                    $this->excel->getActiveSheet()->SetCellValue('D1', lang('product_cost'));
                    $this->excel->getActiveSheet()->SetCellValue('E1', lang('product_price'));
                    $this->excel->getActiveSheet()->SetCellValue('F1', lang('quantity'));
                    $this->excel->getActiveSheet()->SetCellValue('G1', lang('product_unit'));
                    $this->excel->getActiveSheet()->SetCellValue('H1', lang('alert_quantity'));
					                   
                    $row = 2;
                    foreach ($_POST['val'] as $id) {
                        $product = $this->products_model->getProductDetail($id); 
						
                        $product_variants = '';
                        if ($variants) {
                            foreach ($variants as $variant) {
                                $product_variants .= trim($variant->name) . '|';
                            }
                        }
                        $quantity = $product->quantity;
                        if ($wh) {
                            if($wh_qty = $this->products_model->getProductQuantity($id, $wh)) {
                                $quantity = $wh_qty['quantity'];
                            } else {
                                $quantity = 0;
                            }
                        }
                        $this->excel->getActiveSheet()->SetCellValue('A' . $row, $product->code);
                        $this->excel->getActiveSheet()->SetCellValue('B' . $row, $product->name);
                        $this->excel->getActiveSheet()->SetCellValue('C' . $row, $product->category_name);
                        $this->excel->getActiveSheet()->SetCellValue('D' . $row, $product->cost);
                        $this->excel->getActiveSheet()->SetCellValue('E' . $row, $product->price);
                        $this->excel->getActiveSheet()->SetCellValue('F' . $row, $quantity);
                        $this->excel->getActiveSheet()->SetCellValue('G' . $row, $product->un);
                        $this->excel->getActiveSheet()->SetCellValue('H' . $row, $product->alert_quantity);
                        $row++;
                    }

                    $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(30);
                    $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
                    $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                    $filename = 'products_' . date('Y_m_d_H_i_s');
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
                $this->session->set_flashdata('error', $this->lang->line("no_product_selected"));
                redirect($_SERVER["HTTP_REFERER"]);
            }
		} else {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER["HTTP_REFERER"]);
        }
    }
    public function delete_image($id = NULL)
    {
        $this->erp->checkPermissions('edit', true);
        if ($this->input->is_ajax_request()) {
            header('Content-Type: application/json');
            $id || die(json_encode(array('error' => 1, 'msg' => lang('no_image_selected'))));
            $this->db->delete('product_photos', array('id' => $id));
            die(json_encode(array('error' => 0, 'msg' => lang('image_deleted'))));
        }
        die(json_encode(array('error' => 1, 'msg' => lang('ajax_error'))));
    }
	
	public function list_convert(){
		
		$this->erp->checkPermissions('index', true, 'products');
		
		$this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
		$bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('products')));
		$meta = array('page_title' => lang('items_convert'), 'bc' => $bc);
		$this->page_construct('products/list_convert', $meta, $this->data);
	}
	
	public function delete_convert($id = null)
    {
        $this->erp->checkPermissions('delete', true);

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }
        if ($this->products_model->deleteConvert($id) && $this->products_model->deleteConvert_items($id)) {
            echo lang("convert_deleted");
        }
    }
	
	public function product_analysis($id = null)
    {
        //$convert = $this->products_model->getConvertByID($id);
		$deduct = $this->products_model->ConvertDeduct($id);
		$add = $this->products_model->ConvertAdd($id);
        //$this->data['user'] = $this->site->getUser($convert->created_by);
        $this->data['deduct'] = $deduct;
		$this->data['add'] = $add;
		$this->data['logo'] = true;
        $this->data['page_title'] = $this->lang->line("product_analysis");
        $this->load->view($this->theme . 'products/product_anlysis', $this->data);
    }
	
	public function getListConvert()
    {
        $this->erp->checkPermissions('index', true, 'products');
		$add_link = '<a href="' . site_url('products/items_convert') . '"><i class="fa fa-plus-circle"></i> ' . lang('add_convert') . '</a>';
        $analysis_link = anchor('products/product_analysis/$1', '<i class="fa fa-file-text-o"></i> ' . lang('product_analysis'), 'data-toggle="modal" data-target="#myModal2"');
        $edit_link = '<a href="' . site_url('products/edit_convert/$1') . '"><i class="fa fa-edit"></i> ' . lang('edit_convert') . '</a>';
        //$attachment_link = '<a href="'.base_url('assets/uploads/$1').'" target="_blank"><i class="fa fa-chain"></i></a>';
        /*$delete_link = "<a href='#' class='po' title='<b>" . $this->lang->line("delete_expense") . "</b>' data-content=\"<p>"
        . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' href='" . site_url('products/delete_convert/$1') . "'>"
        . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i> "
        . lang('delete_convert') . "</a>";*/
        $action = '<div class="text-center"><div class="btn-group text-left">'
        . '<button type="button" class="btn btn-default btn-xs btn-primary dropdown-toggle" data-toggle="dropdown">'
        . lang('actions') . ' <span class="caret"></span></button>
        <ul class="dropdown-menu pull-right" role="menu">
			<li>' . $add_link . '</li>
            <li>' . $edit_link . '</li>
			<li>' . $analysis_link . '</li>
        </ul>
    </div></div>';

        $this->load->library('datatables');

        $this->datatables
            ->select($this->db->dbprefix('convert') . ".id as id,
					".$this->db->dbprefix('convert').".date AS Date, 
					".$this->db->dbprefix('convert').".reference_no AS Reference, 
					SUM(".$this->db->dbprefix('convert_items').".quantity) AS Quantity, 
					".$this->db->dbprefix('products').".cost AS Cost,
					".$this->db->dbprefix('convert').".noted AS Note,
					".$this->db->dbprefix('warehouses').".name as na,
					CONCAT(" . $this->db->dbprefix('users') . ".first_name, ' ', " . $this->db->dbprefix('users') . ".last_name) as user", false)
            ->from('convert')
            ->join('users', 'users.id=convert.created_by', 'left')
			->join('convert_items', 'convert_items.convert_id = convert.id')
			->join('products', 'convert_items.product_id = products.id')
			->join('warehouses', 'warehouses.id = convert.warehouse_id')
			->where('convert_items.status','add')
            ->group_by('convert.id');
			
        //$this->datatables->edit_column("attachment", $attachment_link, "attachment");
        $this->datatables->add_column("Actions", $action, "id");
        echo $this->datatables->generate();
    }
	
	public function edit_convert($id = null)
    { 
        $this->erp->checkPermissions();
        $this->load->helper('security');
        if ($this->input->post('id')) {
            $id = $this->input->post('id');
        }
         $this->form_validation->set_rules('reference_no', lang("reference_no"), 'required');
		$id_convert_item = 0;
        if ($this->form_validation->run() == true) {
			
			$convert_id = $_POST['convert_id'];
			
			$warehouse_id        = $_POST['warehouse'];
            // list convert item from
            $cIterm_from_id     = $_POST['convert_from_items_id'];
            $cIterm_from_code   = $_POST['convert_from_items_code'];
            $cIterm_from_name   = $_POST['convert_from_items_name'];
            $cIterm_from_uom    = $_POST['convert_from_items_uom'];
            $cIterm_from_qty    = $_POST['convert_from_items_qty'];
            // list convert item to
            $iterm_to_id        = $_POST['convert_to_items_id'];
            $iterm_to_code      = $_POST['convert_to_items_code'];
            $iterm_to_name      = $_POST['convert_to_items_name'];
            $iterm_to_uom      	= $_POST['convert_to_items_uom'];
            $iterm_to_qty       = $_POST['convert_to_items_qty'];
            $data               = array(
									'reference_no' => $_POST['reference_no'],
									'date' => date('Y-m-d h:m', strtotime($_POST['cdate'])),
									'warehouse_id' => $_POST['warehouse'],
									'updated_by' => $this->session->userdata('user_id'),
									'noted' => $_POST['note']
								);			
            $idConvert          = $this->products_model->updateConvert($convert_id,$data);
			$id_convert_item = $idConvert;
			//$this->products_model->deleteConvert_items($convert_id);
            $items = array();
            $i = isset($_POST['convert_from_items_code']) ? sizeof($_POST['convert_from_items_code']) : 0;

            for ($r = 0; $r < $i; $r++) {
                $products   = $this->site->getProductByID($cIterm_from_id[$r]);
				$convert_from = $this->products_model->getConvertItemsByIDPID($convert_id, $cIterm_from_id[$r]);
				$this->products_model->deleteConvert_itemsByPID($convert_id, $cIterm_from_id[$r]);
                if(!empty($cIterm_from_uom[$r])){
                    $product_variant    	= $this->site->getProductVariantByID($cIterm_from_id[$r], $cIterm_from_uom[$r]);
                }else{
                    $product_variant        = $this->site->getProductVariantByID($cIterm_from_id[$r]);
                }
                $PurchaseItemsQtyBalance    =  $this->site->getPurchaseBalanceQuantity($cIterm_from_id[$r], $warehouse_id);
				
				$unit_qty = ( !empty($product_variant->qty_unit) && $product_variant->qty_unit > 0 ? $product_variant->qty_unit : 1 );
				//$this->erp->print_arrays($convert_from);
				
				//get qty from warehouse for update with one pro in two warehouses
                $qtyWarehouse = $this->products_model->getWarehouseQty($cIterm_from_id[$r], $warehouse_id);
                $EachWarehouseQty = ($qtyWarehouse->quantity + $convert_from->quantity) - ($unit_qty  * $cIterm_from_qty[$r]);
                //echo $EachWarehouseQty;exit;
				
                $PurchaseItemsQtyBalance    = ($PurchaseItemsQtyBalance + $convert_from->quantity) - ($unit_qty  * $cIterm_from_qty[$r]);
                $qtyBalace                  = $product_variant->quantity - $cIterm_from_qty[$r];
				$qtytransfer = (-1) * ($unit_qty  * $cIterm_from_qty[$r]);
				
				$purchase_items_id = 0;
				$pis = $this->site->getPurchasedItems($cIterm_from_id[$r], $warehouse_id, $option_id = NULL, $id_convert_item);
				foreach ($pis as $pi) {
					$purchase_items_id = $pi->id;
					break;
				}

				$clause = array('purchase_id' => NULL, 'product_code' => $cIterm_from_code[$r], 'product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id);
				
                if ($pis) {
					$this->db->update('purchase_items', array('quantity_balance' => $qtytransfer, 'quantity' => $qtytransfer), array('id' => $purchase_items_id, 'warehouse_id' => $warehouse_id, 'convert_id' => $id_convert_item));
				} else {
					$clause['item_tax'] = 0;
					$clause['option_id'] = null;
					$clause['convert_id'] = $id_convert_item;
					$clause['product_name'] = $cIterm_from_name[$r];
					$clause['quantity'] = $qtytransfer;
					$clause['quantity_balance'] = $qtytransfer;
					$this->db->insert('purchase_items', $clause);
				}
				// UPDATE PRODUCT QUANTITY
				
                if($this->db->update('products', array('quantity' => $PurchaseItemsQtyBalance), array('code' => $cIterm_from_code[$r])))
				{
					// UPDATE WAREHOUSE_PRODUCT QUANTITY
					if ($this->site->getWarehouseProducts( $cIterm_from_id[$r], $warehouse_id)) {
						$this->db->update('warehouses_products', array('quantity' => $EachWarehouseQty), array('product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id));
					} else {
						$this->db->insert('warehouses_products', array('quantity' => $EachWarehouseQty, 'product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id));
					}
					// UPDATE PRODUCT_VARIANT quantity
					if(!empty($cIterm_from_uom[$r])){
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $cIterm_from_id[$r], 'name' => $cIterm_from_uom[$r]));
					}else{
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $cIterm_from_id[$r]));
					}
				} else {
					exit('error - product');
				}

                $this->db->insert('erp_convert_items',  array(
                                                        'convert_id' => $convert_id,
                                                        'product_id' => $cIterm_from_id[$r],
                                                        'product_code' => $cIterm_from_code[$r],
                                                        'product_name' => $cIterm_from_name[$r],
                                                        'quantity' => $cIterm_from_qty[$r],
                                                        'status' => 'deduct'));
								
				//$this->site->syncQuantity(NULL, $purchase_items_id);
				//$this->site->syncQuantity(NULL, NULL, NULL, $cIterm_from_id[$r]);
            }
            $j = isset($_POST['convert_to_items_code']) ? sizeof($_POST['convert_to_items_code']) : 0;
			$qty_from = '';
            for ($r = 0; $r < $j; $r++) {
				$qty_from += $cIterm_from_qty[$r];
                $products   = $this->site->getProductByID($iterm_to_id[$r]);
				$convert_to = $this->products_model->getConvertItemsByIDPID($convert_id, $iterm_to_id[$r]);
				$this->products_model->deleteConvert_itemsByPID($convert_id, $iterm_to_id[$r]);
                if(!empty($cIterm_from_uom[$r])){
                    $product_variant        = $this->site->getProductVariantByID($iterm_to_id[$r], $iterm_to_uom[$r]);
                }else{
                    $product_variant        = $this->site->getProductVariantByID($iterm_to_id[$r]);
                }
				
                $PurchaseItemsQtyBalance    =  $this->site->getPurchaseBalanceQuantity($iterm_to_id[$r], $warehouse_id);
                $unit_qty = ( !empty($product_variant->qty_unit) && $product_variant->qty_unit > 0 ? $product_variant->qty_unit : 1 );
                $PurchaseItemsQtyBalance    = ($PurchaseItemsQtyBalance - $convert_to->quantity) + ($unit_qty  * $iterm_to_qty[$r]);
                $qtyBalace                  = $product_variant->quantity + $iterm_to_qty[$r];
				$qtytransfer = ($unit_qty  * $iterm_to_qty[$r]);
				
				$qtyWarehouse = $this->products_model->getWarehouseQty($iterm_to_id[$r], $warehouse_id);
                $EachWarehouseQty = ($qtyWarehouse->quantity - $convert_to->quantity) + ($unit_qty  * $iterm_to_qty[$r]);
                //echo $EachWarehouseQty;exit;
				
                $purchase_items_id = 0;
				$pis = $this->site->getPurchasedItems($iterm_to_id[$r], $warehouse_id, $option_id = NULL, $id_convert_item);
				foreach ($pis as $pi) {
					$purchase_items_id = $pi->id;
					break;
				}
				$clause = array('purchase_id' => NULL, 'product_code' => $iterm_to_code[$r], 'product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id);
				
				if ($pis) {
					$this->db->update('purchase_items', array('quantity_balance' => $qtytransfer, 'quantity' => $qtytransfer), array('id' => $purchase_items_id));
				} else {
					$clause['quantity'] = $qtytransfer;
					$clause['item_tax'] = 0;
					$clause['option_id'] = null;
					$clause['convert_id'] = $id_convert_item;
					$clause['product_name'] = $iterm_to_name[$r];
					$clause['quantity_balance'] = $qtytransfer;
					$this->db->insert('purchase_items', $clause);
				}
				
                // UPDATE PRODUCT QUANTITY
				
                if($this->db->update('products', array('quantity' => $PurchaseItemsQtyBalance), array('code' => $iterm_to_code[$r])))
				{
					// UPDATE WAREHOUSE_PRODUCT QUANTITY
					if ($this->site->getWarehouseProducts($iterm_to_id[$r], $warehouse_id)) {
						$this->db->update('warehouses_products', array('quantity' => $EachWarehouseQty), array('product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id));
					} else {
						$this->db->insert('warehouses_products', array('quantity' => $EachWarehouseQty, 'product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id));
					}
					// UPDATE PRODUCT_VARIANT quantity
					if(!empty($cIterm_from_uom[$r])){
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $iterm_to_id[$r], 'name' => $iterm_to_uom[$r]));
					}else{
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $iterm_to_id[$r]));
					}
				} else {
					exit('error increase product ');
				}
				
                $this->db->insert('erp_convert_items', array(
                                                        'convert_id' => $convert_id,
                                                        'product_id' => $iterm_to_id[$r],
                                                        'product_code' => $iterm_to_code[$r],
                                                        'product_name' => $iterm_to_name[$r],
                                                        'quantity' => $iterm_to_qty[$r],
                                                        'status' => 'add'));
				
				//$this->site->syncQuantity(NULL, $purchase_items_id);
				//$this->site->syncQuantity(NULL, NULL, NULL, $cIterm_from_id[$r]);
            }
			
			if($id_convert_item != 0){
                $items = $this->products_model->getConvertItemsById($id_convert_item);
                $deduct = $this->products_model->getConvertItemsDeduct($id_convert_item);
                $adds = $this->products_model->getConvertItemsAdd($id_convert_item);
                $each_cost = 0;
                $total_item = count($adds);
                $old_qty = '';
                foreach($items as $item){
                    if($item->status == 'deduct'){
                        $this->db->update('convert_items', array('cost' => $item->tcost), array('product_id' => $item->product_id, 'convert_id' => $item->convert_id));
                        $old_qty = $item->c_quantity;
                    }else{
                        $each_cost = $deduct->tcost / $total_item;
                        if($this->db->update('convert_items', array('cost' => $each_cost), array('product_id' => $item->product_id, 'convert_id' => $item->convert_id))){
                            $total_net_unit_cost = $each_cost / $item->c_quantity;
                        }
                    }
                }
            }
			
			$new_cost = $this->site->calculateCONAVCost($id_convert_item);
			
            $this->session->set_flashdata('message', lang("item_conitem_convert_success"));
            redirect('products/list_convert');
        }
		
        //$this->erp->print_arrays($this->products_model->getConvert_ItemByID($id));
		
		$this->data['warehouses'] = $this->site->getAllWarehouses();
		$this->data['convert'] = $this->products_model->getConvertByID($id);
		$this->data['convert_items'] = $this->products_model->getConvert_ItemByID($id);
		$this->data['bom'] = $this->products_model->getAllBoms();
		
		$bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('edit_product')));
		$meta = array('page_title' => lang('edit_convert'), 'bc' => $bc);
		
		$this->page_construct('products/edit_convert', $meta, $this->data);
    }
	
	
	public function convert_actions()
    {
        if (!$this->Owner) {
            $this->session->set_flashdata('warning', lang('access_denied'));
            redirect($_SERVER["HTTP_REFERER"]);
        }

        $this->form_validation->set_rules('form_action', lang("form_action"), 'required');

        if ($this->form_validation->run() == true) {
		
            if (!empty($_POST['val'])) {
                if ($this->input->post('form_action') == 'delete') {
                    foreach ($_POST['val'] as $id) {
                        $this->products_model->deleteConvert($id);
						$this->products_model->deleteConvert_items($id);
                    }
                    $this->session->set_flashdata('message', $this->lang->line("convert_deleted"));
                    redirect($_SERVER["HTTP_REFERER"]);
                }

                if ($this->input->post('form_action') == 'export_excel' || $this->input->post('form_action') == 'export_pdf') {

                    $this->load->library('excel');
                    $this->excel->setActiveSheetIndex(0);
                    $this->excel->getActiveSheet()->setTitle(lang('convert'));
                    $this->excel->getActiveSheet()->SetCellValue('A1', lang('date'));
                    $this->excel->getActiveSheet()->SetCellValue('B1', lang('reference'));
                    $this->excel->getActiveSheet()->SetCellValue('C1', lang('quantity_convert'));
					$this->excel->getActiveSheet()->SetCellValue('D1', lang('cost'));
                    $this->excel->getActiveSheet()->SetCellValue('E1', lang('note'));
                    $this->excel->getActiveSheet()->SetCellValue('F1', lang('created_by'));

                    $row = 2;
                    foreach ($_POST['val'] as $id) {
                        $converts = $this->products_model->getConvertByID($id);
						//$this->erp->print_arrays($converts); 
                        $user = $this->site->getUser($converts->created_by);
                        $this->excel->getActiveSheet()->SetCellValue('A' . $row, $this->erp->hrld($converts->date));
                        $this->excel->getActiveSheet()->SetCellValue('B' . $row, $converts->reference_no);
                        $this->excel->getActiveSheet()->SetCellValue('C' . $row, $this->erp->formatMoneyPurchase($converts->Quantity));
						$this->excel->getActiveSheet()->SetCellValue('D' . $row, $this->erp->formatMoneyPurchase($converts->cost));
                        $this->excel->getActiveSheet()->SetCellValue('E' . $row, $converts->noted);
                        $this->excel->getActiveSheet()->SetCellValue('F' . $row, $user->first_name . ' ' . $user->last_name);
                        $row++;
                    }

                    $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
					$this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                    $this->excel->getActiveSheet()->getColumnDimension('E')->setWidth(40);
					$this->excel->getActiveSheet()->getColumnDimension('F')->setWidth(30);
                    $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                    $filename = 'convert_' . date('Y_m_d_H_i_s');
                    if ($this->input->post('form_action') == 'export_pdf') {
                        $styleArray = array('borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN)));
                        $this->excel->getDefaultStyle()->applyFromArray($styleArray);
                        $this->excel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
                        require_once APPPATH . "third_party" . DIRECTORY_SEPARATOR . "MPDF" . DIRECTORY_SEPARATOR . "mpdf.php";
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
                $this->session->set_flashdata('error', $this->lang->line("no_convert_selected"));
                redirect($_SERVER["HTTP_REFERER"]);
            }
        } else {
            $this->session->set_flashdata('error', validation_errors());
            redirect($_SERVER["HTTP_REFERER"]);
        }
    }
	
	function items_convert()
    {
        $this->erp->checkPermissions('index', true, 'products');
        $this->form_validation->set_rules('reference_no', lang("reference_no"), 'required');
		$id_convert_item = 0;
        if ($this->form_validation->run() == true) {
			$warehouse_id        = $_POST['warehouse'];
            // list convert item from
            $cIterm_from_id     = $_POST['convert_from_items_id'];
            $cIterm_from_code   = $_POST['convert_from_items_code'];
            $cIterm_from_name   = $_POST['convert_from_items_name'];
            $cIterm_from_uom    = $_POST['convert_from_items_uom'];
            $cIterm_from_qty    = $_POST['convert_from_items_qty'];
            // list convert item to
            $iterm_to_id        = $_POST['convert_to_items_id'];
            $iterm_to_code      = $_POST['convert_to_items_code'];
            $iterm_to_name      = $_POST['convert_to_items_name'];
            $iterm_to_uom       = $_POST['convert_to_items_uom'];
            $iterm_to_qty       = $_POST['convert_to_items_qty'];
            $data               = array(
                                        'reference_no' => $_POST['reference_no']?$_POST['reference_no']:$this->site->getReference('con'),
                                        'date' => $this->erp->fld($_POST['sldate']),
										'warehouse_id' => $_POST['warehouse'],
                                        'created_by' => $this->session->userdata('user_id'),
										'noted' => $_POST['note'],
										'bom_id' => $_POST['bom_id']
                                    );
			//$this->erp->print_arrays($data);
			
            $idConvert          = $this->products_model->insertConvert($data);
			$id_convert_item = $idConvert;	
            $items = array();
            $i = isset($_POST['convert_from_items_code']) ? sizeof($_POST['convert_from_items_code']) : 0;
			$qty_from = '';
			$total_cost = '';
            for ($r = 0; $r < $i; $r++) {
				$qty_from += $cIterm_from_qty[$r];
                $product_fr   = $this->site->getProductByID($cIterm_from_id[$r]);
				$total_cost += ($cIterm_from_qty[$r] * $product_fr->cost);
                if(!empty($cIterm_from_uom[$r])){
                    $product_variant    	= $this->site->getProductVariantByID($cIterm_from_id[$r], $cIterm_from_uom[$r]);
					//$this->erp->print_arrays($product_variant);
                }else{
                    $product_variant        = $this->site->getProductVariantByID($cIterm_from_id[$r]);
                }
				
                $PurchaseItemsQtyBalance    =  $this->site->getProductQty($cIterm_from_id[$r]);
				
				$unit_qty = ( !empty($product_variant->qty_unit) && $product_variant->qty_unit > 0 ? $product_variant->qty_unit : 1 );
				//echo $unit_qty;exit;
				
				//get qty from warehouse for update with one pro in two warehouses
                $qtyWarehouse = $this->products_model->getWarehouseQty($cIterm_from_id[$r], $warehouse_id);
                $EachWarehouseQty = $qtyWarehouse->quantity - ($unit_qty  * $cIterm_from_qty[$r]);
                //echo $EachWarehouseQty;exit;
				
                $PurchaseItemsQtyBalance    = $PurchaseItemsQtyBalance - ($unit_qty  * $cIterm_from_qty[$r]);
				
				$qtytransfer = (-1) * ($unit_qty  * $cIterm_from_qty[$r]);
				
                $qtyBalace                  = $product_variant->quantity - $cIterm_from_qty[$r];
				
				$purchase_items_id = 0;
				$pis = $this->site->getPurchasedItems($cIterm_from_id[$r], $warehouse_id, $option_id = NULL);
				
				foreach ($pis as $pi) {
					$purchase_items_id = $pi->id;
					break;
				}
				$clause = array('purchase_id' => NULL, 'product_code' => $cIterm_from_code[$r], 'product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id);
				
				$clause['quantity'] = $qtytransfer;
				$clause['item_tax'] = 0;
				$clause['option_id'] = null;
				$clause['convert_id'] = $id_convert_item;
				$clause['product_name'] = $cIterm_from_name[$r];
				$clause['quantity_balance'] = $qtytransfer;
				$this->db->insert('purchase_items', $clause);
				
				/*if ($pis) {
					$this->db->update('purchase_items', array('quantity_balance' => $PurchaseItemsQtyBalance), array('id' => $purchase_items_id, 'warehouse_id' => $warehouse_id));
				} else {
					$clause['quantity'] = 0;
					$clause['item_tax'] = 0;
					$clause['option_id'] = null;
					$clause['transfer_id'] = null;
					$clause['product_name'] = $cIterm_from_name[$r];
					$clause['quantity_balance'] = $PurchaseItemsQtyBalance;
					$this->db->insert('purchase_items', $clause);
				}
				*/
				
                // UPDATE PRODUCT QUANTITY
				//echo $PurchaseItemsQtyBalance;exit;
                /*
				if($this->db->update('products', array('quantity' => $PurchaseItemsQtyBalance), array('code' => $cIterm_from_code[$r])))
				{
					// UPDATE WAREHOUSE_PRODUCT QUANTITY
					if ($this->site->getWarehouseProducts( $cIterm_from_id[$r], $warehouse_id)) {
						$this->db->update('warehouses_products', array('quantity' => $EachWarehouseQty), array('product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id));
					} else {
						$this->db->insert('warehouses_products', array('quantity' => $EachWarehouseQty, 'product_id' => $cIterm_from_id[$r], 'warehouse_id' => $warehouse_id));
					}
					// UPDATE PRODUCT_VARIANT quantity
					if(!empty($cIterm_from_uom[$r])){
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $cIterm_from_id[$r], 'name' => $cIterm_from_uom[$r]));
					}else{
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $cIterm_from_id[$r]));
					}
				} else {
					exit('error - product');
				}
				*/
                $this->db->insert('erp_convert_items',  array(
                                                        'convert_id' => $idConvert,
                                                        'product_id' => $cIterm_from_id[$r],
                                                        'product_code' => $cIterm_from_code[$r],
                                                        'product_name' => $cIterm_from_name[$r],
                                                        'quantity' => $cIterm_from_qty[$r],
                                                        'status' => 'deduct'));
							
				//$this->site->syncQuantity(NULL, $purchase_items_id);
				$this->site->syncQuantity(NULL, NULL, NULL, $cIterm_from_id[$r]);
            }
            $j = isset($_POST['convert_to_items_code']) ? sizeof($_POST['convert_to_items_code']) : 0;
			$qty_to = '';
            for ($r = 0; $r < $j; $r++) {
				//$qty_to += $iterm_to_qty[$r];
                $products = $this->site->getProductByID($iterm_to_id[$r]);
				$pro_cost = $this->site->AverageCost($total_cost, $iterm_to_qty[$r], $products->cost, $products->quantity);
                if(!empty($cIterm_from_uom[$r])){
                    $product_variant        = $this->site->getProductVariantByID($iterm_to_id[$r], $iterm_to_uom[$r]);
                }else{
                    $product_variant        = $this->site->getProductVariantByID($iterm_to_id[$r]);
                }

                $PurchaseItemsQtyBalance    =  $this->site->getProductQty($iterm_to_id[$r]);

                $unit_qty = ( !empty($product_variant->qty_unit) && $product_variant->qty_unit > 0 ? $product_variant->qty_unit : 1 );
				
				$qtyWarehouse = $this->products_model->getWarehouseQty($iterm_to_id[$r], $warehouse_id);
                $EachWarehouseQty = $qtyWarehouse->quantity + ($unit_qty  * $iterm_to_qty[$r]);
                //echo $EachWarehouseQty;exit;
				
                $PurchaseItemsQtyBalance    = $PurchaseItemsQtyBalance + ($unit_qty  * $iterm_to_qty[$r]);
                $qtyBalace                  = $product_variant->quantity + $iterm_to_qty[$r];
				$qtytransfer = ($unit_qty  * $iterm_to_qty[$r]);

                $purchase_items_id = 0;
				$pis = $this->site->getPurchasedItems($iterm_to_id[$r], $warehouse_id, $option_id = NULL);
				foreach ($pis as $pi) {
					$purchase_items_id = $pi->id;
					break;
				}
				$clause = array('purchase_id' => NULL, 'product_code' => $iterm_to_code[$r], 'product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id);
				
				$clause['quantity'] = $qtytransfer;
				$clause['item_tax'] = 0;
				$clause['option_id'] = null;
				$clause['convert_id'] = $id_convert_item;
				$clause['product_name'] = $iterm_to_name[$r];
				$clause['quantity_balance'] = $qtytransfer;
				$this->db->insert('purchase_items', $clause);
				
				/*if ($pis) {
					$this->db->update('purchase_items', array('quantity_balance' => $PurchaseItemsQtyBalance), array('id' => $purchase_items_id));
				} else {
					$clause['quantity'] = 0;
					$clause['item_tax'] = 0;
					$clause['option_id'] = null;
					$clause['transfer_id'] = null;
					$clause['product_name'] = $iterm_to_name[$r];
					$clause['quantity_balance'] = $PurchaseItemsQtyBalance;
					$this->db->insert('purchase_items', $clause);
				}*/
                // UPDATE PRODUCT QUANTITY
				//$this->erp->print_arrays($iterm_to_code);
				/*
				$upPro = $this->site->updateQualityPro(array('quantity' => $PurchaseItemsQtyBalance), $iterm_to_code[$r]);
                if($upPro)
				{
					// UPDATE WAREHOUSE_PRODUCT QUANTITY
					if ($this->site->getWarehouseProducts($iterm_to_id[$r], $warehouse_id)) {
						$this->db->update('warehouses_products', array('quantity' => $EachWarehouseQty), array('product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id));
					} else {
						$this->db->insert('warehouses_products', array('quantity' => $EachWarehouseQty, 'product_id' => $iterm_to_id[$r], 'warehouse_id' => $warehouse_id));
					}
					// UPDATE PRODUCT_VARIANT quantity
					if(!empty($cIterm_from_uom[$r])){
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $iterm_to_id[$r], 'name' => $iterm_to_uom[$r]));
					}else{
						$this->db->update('product_variants', array('quantity' => $qtyBalace), array('product_id' => $iterm_to_id[$r]));
					}
				} else {
					exit('error increase product ');
				}
				*/
                $this->db->insert('erp_convert_items', array(
                                                        'convert_id' => $idConvert,
                                                        'product_id' => $iterm_to_id[$r],
                                                        'product_code' => $iterm_to_code[$r],
                                                        'product_name' => $iterm_to_name[$r],
                                                        'quantity' => $iterm_to_qty[$r],
                                                        'status' => 'add'));
				
				//$this->site->syncQuantity(NULL, $purchase_items_id);
				$this->site->syncQuantity(NULL, NULL, NULL, $iterm_to_id[$r]);
				
				//$upPros = $this->site->updateCostPro(array('cost' => $new_cost), $iterm_to_id[$r]);
				
				$this->db->update('products', array('cost' => $pro_cost), array('id' => $iterm_to_id[$r]));
				
            }
			$qty_to = implode(',',$iterm_to_qty);
			$qty_toex = explode(',',$qty_to);
			foreach($qty_toex as $QTo){
				if(count($qty_toex) > 1){
					$num = $qty_from - $QTo;
					$final_num = $qty_from - $num;
					$new_cost = $this->site->calculateCONAVCost($id_convert_item, $QTo, $final_num);
					$upPros = $this->site->updateCostPro(array('cost' => $new_cost), $iterm_to_id);
				}else{
					$new_cost = $this->site->calculateCONAVCost($id_convert_item, $QTo, $qty_from);
					$upPros = $this->site->updateCostPro(array('cost' => $new_cost), $iterm_to_id);
				}
			}
			
			if($id_convert_item != 0){
				$items = $this->products_model->getConvertItemsById($id_convert_item);
				$deduct = $this->products_model->getConvertItemsDeduct($id_convert_item);
				$adds = $this->products_model->getConvertItemsAdd($id_convert_item);
				$each_cost = 0;
				$total_item = count($adds);
				$old_qty = '';
				foreach($items as $item){
					if($item->status == 'deduct'){
						$this->db->update('convert_items', array('cost' => $item->tcost), array('product_id' => $item->product_id, 'convert_id' => $item->convert_id));
						$old_qty = $item->c_quantity;
					}else{
						$each_cost = $deduct->tcost / $total_item;
						if($this->db->update('convert_items', array('cost' => $each_cost), array('product_id' => $item->product_id, 'convert_id' => $item->convert_id))){
							//foreach($adds as $add){
								$total_net_unit_cost = $each_cost / $item->c_quantity;
								//$total_quantity += $each_cost;
								//$total_unit_cost += ($pi->unit_cost ? ($pi->unit_cost *  $pi->quantity_balance) : ($pi->net_unit_cost + ($pi->item_tax / $pi->quantity) *  $pi->quantity_balance));
							//}
							
							
							//$new_cost_from = ($old_qty * $product_fr->cost) / $item->c_quantity;
							//$cost_avgs = ($new_cost_from * $item->c_quantity) / ($product_fr->quantity *  $product_fr->cost);
							//$this->db->update('products', array('cost' => $new_cost_from), array('id' => $item->product_id));
							//$avg_net_unit_cost = $total_net_unit_cost / $total_quantity;
							//$avg_unit_cost = $total_unit_cost / $total_quantity;

							//$cost2 = $each_cost * $item->p_cost;
							
							//$product_cost = ($total_net_unit_cost + $cost2) / $total_quantity;
						}
					}
				}
			}
			
            $this->session->set_flashdata('message', lang("item_conitem_convert_success"));
            redirect('products/items_convert');
        }else{
			$this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
			$reference = $this->products_model->getReference();
			foreach($reference as $reference_no){
				if($this->site->getReference('con') == $reference_no->reference_no){
					$this->site->updateReference('con'); 
				}
			}
			
			$this->data['conumber'] = $this->site->getReference('con');
			//$this->site->updateReference('con'); 
			$this->data['warehouses'] = $this->site->getAllWarehouses();
			$this->data['tax_rates'] = $this->site->getAllTaxRates();
			$this->data['bom'] = $this->products_model->getAllBoms();
			$bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('products')));
			$meta = array('page_title' => lang('items_convert'), 'bc' => $bc);
			$this->page_construct('products/items_convert', $meta, $this->data);
		}
    }
	
	public function testConvert($convert_id, $qty_to, $qty_from){
		$r = $this->site->calculateCONAVCost($convert_id, $qty_to, $qty_from);
		echo 'Average Cost Convert' . $r;
	}
	
	/* Products Return */
	function return_products($warehouse_id = NULL)
    {
        $this->erp->checkPermissions();

        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        if ($this->Owner) {
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['warehouse_id'] = $warehouse_id;
            $this->data['warehouse'] = $warehouse_id ? $this->site->getWarehouseByID($warehouse_id) : NULL;
        } else {
            $user = $this->site->getUser();
            $this->data['warehouses'] = NULL;
            $this->data['warehouse_id'] = $user->warehouse_id;
            $this->data['warehouse'] = $user->warehouse_id ? $this->site->getWarehouseByID($user->warehouse_id) : NULL;
        }

        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => '#', 'page' => lang('return_products')));
        $meta = array('page_title' => lang('return_products'), 'bc' => $bc);
        $this->page_construct('products/return_products', $meta, $this->data);
    }

    function getReturns($warehouse_id = NULL)
    {
        $this->erp->checkPermissions('return_products');
		
		if ($this->input->get('user')) {
            $user_query = $this->input->get('user');
        } else {
            $user_query = NULL;
        }
        if ($this->input->get('reference_no')) {
            $reference_no = $this->input->get('reference_no');
        } else {
            $reference_no = NULL;
        }
        if ($this->input->get('customer')) {
            $customer = $this->input->get('customer');
        } else {
            $customer = NULL;
        }
        if ($this->input->get('biller')) {
            $biller = $this->input->get('biller');
        } else {
            $biller = NULL;
        }
		if ($this->input->get('warehouse')) {
            $warehouse = $this->input->get('warehouse');
        } else {
            $warehouse = NULL;
        }
        if ($this->input->get('start_date')) {
            $start_date = $this->input->get('start_date');
        } else {
            $start_date = NULL;
        }
        if ($this->input->get('end_date')) {
            $end_date = $this->input->get('end_date');
        } else {
            $end_date = NULL;
        }
        if ($start_date) {
            $start_date = $this->erp->fld($start_date);
            $end_date = $this->erp->fld($end_date);
        }

        if ((! $this->Owner || ! $this->Admin) && ! $warehouse_id) {
            $user = $this->site->getUser();
            $warehouse_id = $user->warehouse_id;
        }
		
		
        if (!$this->Owner && !$warehouse_id) {
            $user = $this->site->getUser();
            $warehouse_id = $user->warehouse_id;
        }
        $detail_link = anchor('sales/view/$1', '<i class="fa fa-file-text-o"></i>');
        $edit_link = ''; //anchor('sales/edit/$1', '<i class="fa fa-edit"></i>', 'class="reedit"');
        $delete_link = "<a href='#' class='po' title='<b>" . lang("delete_return_sale") . "</b>' data-content=\"<p>"
            . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' href='" . site_url('sales/delete_return/$1') . "'>"
            . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i></a>";
        $action = '<div class="text-center">' . $detail_link . ' ' . $edit_link . ' ' . $delete_link . '</div>';
        //$action = '<div class="text-center">' . $detail_link . ' ' . $edit_link . ' ' . $email_link . ' ' . $delete_link . '</div>';

        $this->load->library('datatables');
        if ($warehouse_id) {
            $this->datatables
                ->select($this->db->dbprefix('return_sales') . ".date as date, " . $this->db->dbprefix('sales') . ".reference_no as ref, ABS(" . $this->db->dbprefix('return_items') . ".quantity) as qty, " . $this->db->dbprefix('return_sales') . ".biller, " . $this->db->dbprefix('return_sales') . ".customer, " . $this->db->dbprefix('users') . ".username, " . $this->db->dbprefix('return_sales') . ".id as id")
                ->join('sales', 'sales.id=return_sales.sale_id', 'left')
				->join('return_items', 'return_items.return_id = return_sales.id', 'left')
				->join('users', 'users.id = return_sales.created_by', 'left')
                ->from('return_sales')
                ->group_by('return_sales.id')
                ->where('return_sales.warehouse_id', $warehouse_id);
        } else {
            $this->datatables
                ->select($this->db->dbprefix('return_sales') . ".date as date, " . $this->db->dbprefix('sales') . ".reference_no as ref, ABS(" . $this->db->dbprefix('return_items') . ".quantity) as qty, " . $this->db->dbprefix('return_sales') . ".biller, " . $this->db->dbprefix('return_sales') . ".customer, " . $this->db->dbprefix('users') . ".username, " . $this->db->dbprefix('return_sales') . ".id as id")
                ->join('sales', 'sales.id=return_sales.sale_id', 'left')
				->join('return_items', 'return_items.return_id = return_sales.id','left')
				->join('users', 'users.id = return_sales.created_by', 'left')
                ->from('return_sales')
                ->group_by('return_sales.id');
        }
        if (!$this->Customer && !$this->Supplier && !$this->Owner && !$this->Admin) {
            $this->datatables->where('return_sales.created_by', $this->session->userdata('user_id'));
        } elseif ($this->Customer) {
            $this->datatables->where('return_sales.customer_id', $this->session->userdata('customer_id'));
        }
		
		if ($user_query) {
			$this->datatables->where('sales.created_by', $user_query);
		}/*
		if ($customer) {
			$this->datatables->where('sales.id', $customer);
		}*/
		if ($reference_no) {
			$this->datatables->where('sales.reference_no', $reference_no);
		}
		if ($biller) {
			$this->datatables->where('sales.biller_id', $biller);
		}
		if ($customer) {
			$this->datatables->where('sales.customer_id', $customer);
		}
		if ($warehouse) {
			$this->datatables->where('sales.warehouse_id', $warehouse);
		}

		if ($start_date) {
			$this->datatables->where($this->db->dbprefix('return_sales').'.date BETWEEN "' . $start_date . '" AND "' . $end_date . '"');
		}
		
        $this->datatables->add_column("Actions", $action, "id");
        echo $this->datatables->generate();
    }
	
	/*
	function view_return($id = NULL)
    {
        $this->erp->checkPermissions('return_sales');

        if ($this->input->get('id')) {
            $id = $this->input->get('id');
        }
        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $inv = $this->sales_model->getReturnByID($id);
        $this->erp->view_rights($inv->created_by);
        $this->data['barcode'] = "<img src='" . site_url('products/gen_barcode/' . $inv->reference_no) . "' alt='" . $inv->reference_no . "' class='pull-left' />";
        $this->data['customer'] = $this->site->getCompanyByID($inv->customer_id);
        $this->data['payments'] = $this->sales_model->getPaymentsForSale($id);
        $this->data['biller'] = $this->site->getCompanyByID($inv->biller_id);
        $this->data['user'] = $this->site->getUser($inv->created_by);
        $this->data['warehouse'] = $this->site->getWarehouseByID($inv->warehouse_id);
        $this->data['inv'] = $inv;
        $this->data['rows'] = $this->sales_model->getAllReturnItems($id);
        $this->data['sale'] = $this->sales_model->getInvoiceByID($inv->sale_id);
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('view_return')));
        $meta = array('page_title' => lang('view_return_details'), 'bc' => $bc);
        $this->page_construct('products/view_return', $meta, $this->data);
    }*/

	function getDatabyBom_id(){
		$id = $this->input->get('term', TRUE);
		$result = $this->products_model->getAllBom_id($id);
		echo json_encode($result);
	}
	
	
    function product_serial()
    {
        $this->erp->checkPermissions('adjustments');

        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');

        $data['warehouses'] = $this->site->getAllWarehouses();

        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('product_serial')));
        $meta = array('page_title' => lang('product_serial'), 'bc' => $bc);
        $this->page_construct('products/product_serial', $meta, $this->data);
    }

    function getProductSerial($pdf = NULL, $xls = NULL)
    {
        $this->erp->checkPermissions('adjustments');

        $product = $this->input->get('product') ? $this->input->get('product') : NULL;

        if ($pdf || $xls) {

            $this->db
                ->select($this->db->dbprefix('adjustments') . ".id as did, " . $this->db->dbprefix('adjustments') . ".product_id as productid, " . $this->db->dbprefix('adjustments') . ".date as date, " . $this->db->dbprefix('products') . ".image as image, " . $this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as pname, " . $this->db->dbprefix('product_variants') . ".name as vname, " . $this->db->dbprefix('adjustments') . ".quantity as quantity, ".$this->db->dbprefix('adjustments') . ".type, " . $this->db->dbprefix('warehouses') . ".name as wh");
            $this->db->from('adjustments');
            $this->db->join('products', 'products.id=adjustments.product_id', 'left');
            $this->db->join('product_variants', 'product_variants.id=adjustments.option_id', 'left');
            $this->db->join('warehouses', 'warehouses.id=adjustments.warehouse_id', 'left');
            $this->db->group_by("adjustments.id")->order_by('adjustments.date desc');
            if ($product) {
                $this->db->where('adjustments.product_id', $product);
            }

            $q = $this->db->get();
            if ($q->num_rows() > 0) {
                foreach (($q->result()) as $row) {
                    $data[] = $row;
                }
            } else {
                $data = NULL;
            }

            if (!empty($data)) {

                $this->load->library('excel');
                $this->excel->setActiveSheetIndex(0);
                $this->excel->getActiveSheet()->setTitle(lang('quantity_adjustments'));
                $this->excel->getActiveSheet()->SetCellValue('A1', lang('date'));
                $this->excel->getActiveSheet()->SetCellValue('B1', lang('product_code'));
                $this->excel->getActiveSheet()->SetCellValue('C1', lang('product_name'));
                $this->excel->getActiveSheet()->SetCellValue('D1', lang('product_variant'));
                $this->excel->getActiveSheet()->SetCellValue('E1', lang('quantity'));
                $this->excel->getActiveSheet()->SetCellValue('F1', lang('type'));
                $this->excel->getActiveSheet()->SetCellValue('G1', lang('warehouse'));

                $row = 2;
                foreach ($data as $data_row) {
                    $this->excel->getActiveSheet()->SetCellValue('A' . $row, $this->erp->hrld($data_row->date));
                    $this->excel->getActiveSheet()->SetCellValue('B' . $row, $data_row->code);
                    $this->excel->getActiveSheet()->SetCellValue('C' . $row, $data_row->pname);
                    $this->excel->getActiveSheet()->SetCellValue('D' . $row, $data_row->vname);
                    $this->excel->getActiveSheet()->SetCellValue('E' . $row, $data_row->quantity);
                    $this->excel->getActiveSheet()->SetCellValue('F' . $row, lang($data_row->type));
                    $this->excel->getActiveSheet()->SetCellValue('G' . $row, $data_row->wh);
                    $row++;
                }

                $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
                $filename = lang('quantity_adjustments');
                $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                if ($pdf) {
                    $styleArray = array(
                        'borders' => array(
                            'allborders' => array(
                                'style' => PHPExcel_Style_Border::BORDER_THIN
                            )
                        )
                    );
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
                    $objWriter->save('php://output');
                    exit();
                }
                if ($xls) {
                    ob_clean();
                    header('Content-Type: application/vnd.ms-excel');
                    header('Content-Disposition: attachment;filename="' . $filename . '.xls"');
                    header('Cache-Control: max-age=0');
                    ob_clean();
                    $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'Excel5');
                    $objWriter->save('php://output');
                    exit();
                }

            }

            $this->session->set_flashdata('error', lang('nothing_found'));
            redirect($_SERVER["HTTP_REFERER"]);

        } else {

            $delete_link = "<a href='#' class='tip po' title='<b>" . $this->lang->line("delete_adjustment") . "</b>' data-content=\"<p>"
                . lang('r_u_sure') . "</p><a class='btn btn-danger po-delete' id='a__$1' href='" . site_url('products/delete_adjustment/$2') . "'>"
                . lang('i_m_sure') . "</a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i></a>";

            $this->load->library('datatables');
            $this->datatables
                ->select($this->db->dbprefix('products') . ".code as code, " . $this->db->dbprefix('products') . ".name as name, " . $this->db->dbprefix('companies') . ".company as company, " . $this->db->dbprefix('warehouses') . ".name as warehouse, " . $this->db->dbprefix('serial') . ".serial_number as number, ".$this->db->dbprefix('serial') . ".serial_status as sstatus");
            $this->datatables->from('serial');
            $this->datatables->join('products', 'products.id=serial.product_id', 'left');
            $this->datatables->join('companies', 'companies.id=serial.biller_id', 'left');
            $this->datatables->join('warehouses', 'warehouses.id=serial.warehouse', 'left');
            $this->datatables->add_column("Actions", "<div class='text-center'><a href='" . site_url('products/edit_adjustment/$1/$2') . "' class='tip' title='" . lang("edit_adjustment") . "' data-toggle='modal' data-target='#myModal'><i class='fa fa-edit'></i></a> " . $delete_link . "</div>", "did");
            if ($product) {
                $this->datatables->where('serial.product_id', $product);
            }

            echo $this->datatables->generate();

        }

    }
	public function enter_using_stock(){
		$this->erp->checkPermissions('adjustments');
        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['warehouses'] = $this->site->getAllWarehouses();
		$AllUsers=$this->site->getAllUsers();
		$CurrentUser=$this->site->getUser();
		$setting=$this->site->get_setting();
		$biller=$this->site->getAllBiller();
		$employee=$this->site->getAllEmployee();
		$all_unit=$this->site->getUnits();
		$product=$this->products_model->getProductName_code();
		$getGLChart=$this->products_model->getGLChart();
        $this->data['getGLChart'] = $getGLChart; 
        $this->data['AllUsers'] = $AllUsers; 
        $this->data['CurrentUser'] = $CurrentUser; 
        $this->data['setting'] = $setting; 
        $this->data['biller'] = $biller; 
        $this->data['all_unit'] = $all_unit; 
        $this->data['employees'] = $employee; 
        $this->data['product'] = $product; 
        $this->data['productJSON'] = json_encode($product); 
		$this->data['reference'] = $this->site->getReference('es');
		
		$this->data['modal_js'] = $this->site->modal_js();
		//$this->erp->print_arrays($data);
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('enter_using_stock')));
        $meta = array('page_title' => lang('enter_using_stock'), 'bc' => $bc);
        $this->page_construct('products/enter_using_stock', $meta, $this->data);
	}
	
	function getProductByWarehouses()
    {
		$product=array();
        $w_id = $this->input->get('w_id');
		$product = $this->products_model->getProductName_code($w_id);
		echo json_encode($product);
    }
	
	public function add_enter_using_stock()
	{
		$date = $this->erp->fld(trim($this->input->post('date')));
		$reference_no 	 = $this->input->post('reference_no');
		$warehouse_id 	 = $this->input->post('from_location');
		$authorize_id 	 = $this->input->post('authorize_id');
		$employee_id 	 = $this->input->post('employee_id');
		$shop 	 		 = $this->input->post('shop');
		$account 	 	 = $this->input->post('account');
		$note 	 		 = $this->input->post('note');
		$cost 	 		 = $this->input->post('cost');
		
		$ref_prefix 	 = $this->input->post('ref_prefix');

		$item_code_arr 	 = $this->input->post('item_code');
		$description_arr = $this->input->post('description');
		$reason_arr 	 = $this->input->post('reason');
		$qty_use_arr 	 = $this->input->post('qty_use');
		$unit_arr 	 	 = $this->input->post('unit');
		$wh_id_arr 	 	 = $this->input->post('wh_id');
		$qty_arr         = $this->input->post('qty_use');
		$total_item_cost = 0;
		$i=0;
		foreach($item_code_arr as $item_code){
			$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
			$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
			
			$total_cost=$cost[$i]*$convert_qty;
			$total_item_cost+=$total_cost;
			//echo $qty_arr[$i].' * '.$total_cost.'='.$total_item_cost.'<br/>';
			$i++;
		}

		$CurrentUser=$this->site->getUser();
		$data = array(
			'date' => $date,
			'reference_no' => $reference_no,
			'warehouse_id' => $warehouse_id,
			'authorize_id' => $authorize_id,
			'employee_id' => $employee_id,
			'shop' => $shop,
			'account' => $account,
			'note' => $note,
			'create_by' => $CurrentUser->id,
			'type' => 'use',
			'total_cost' =>	$total_item_cost,
		);
		$insert_enter_using_stock=$this->products_model->insert_enter_using_stock($data,$ref_prefix);
		
		$i = 0;
		foreach($item_code_arr as $item_code){
			$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
			
			$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				$item_data = array(
							'code' => $item_code_arr[$i],
							'description' => $description_arr[$i],
							'reason' => $reason_arr[$i],
							'qty_use' => $convert_qty,
							'qty_by_unit' => $qty_use_arr[$i],
							'unit' => $unit_arr[$i],
							'warehouse_id' => $wh_id_arr[$i],
							'cost' => $cost[$i],
							'reference_no' => $reference_no,
						);
				$insert_enter_using_stock_item=$this->products_model->insert_enter_using_stock_item($item_data);
				if($insert_enter_using_stock_item){
					$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
					$product_id=$product->id;
					$product_code=$product->code;
					$product_name=$product->name;
					$net_unit_cost=$product->price;
					$pur_data = array(
						'product_id' => $product_id,
						'product_code' => $product_code,
						'product_name' => $product_name,
						'net_unit_cost' => $product->cost,
						'option_id' => $unit_of_measure->id,
						'quantity' => -1 * abs($convert_qty),
						'reference'=>$reference_no,
						'warehouse_id' => $wh_id_arr[$i],
						'subtotal' => $pr_item->subtotal?$pr_item->subtotal:0,
						'date' => $date,
						'status' => '',
						'net_unit_cost' => $net_unit_cost,
						'quantity_balance' => -1 * abs($convert_qty)
					);
					$this->db->insert('purchase_items', $pur_data);
					$this->site->syncProductQty($product_id, $wh_id_arr[$i]);
				}
					$i++;	
		}		
		if($insert_enter_using_stock_item && $insert_enter_using_stock){
			$this->session->set_flashdata(lang('enter_using_stock_added.'));
				$r_r=str_replace("/","-",$reference_no);
				
				redirect('products/print_enter_using_stock/'.$r_r);
		}else{
			$this->session->set_flashdata('error', $error);
				redirect($_SERVER["HTTP_REFERER"]);
		}
		
	}
	public function getUnitOfMeasureByProductCode(){
			$code = $this->input->get('product_code', TRUE);
			$unit_of_measure = $this->products_model->getUnitOfMeasureByProductCode($code);
			echo json_encode($unit_of_measure);
	}
	function print_enter_using_stock($ref)
    {
		$r_r=str_replace("-","/",$ref);
        $using_stock=$this->products_model->get_enter_using_stock_by_ref($r_r);
        $stock_item=$this->products_model->get_enter_using_stock_item_by_ref($r_r);
		 $this->data['using_stock'] = $using_stock; 
		 $this->data['stock_item'] = $stock_item; 
        $this->load->view($this->theme.'products/print_enter_using_stock',$this->data);
    }
	function view_using_stock(){
		$this->erp->checkPermissions('adjustments');
        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['warehouses'] = $this->site->getAllWarehouses();
		$AllUsers=$this->site->getAllUsers();
		$CurrentUser=$this->site->getUser();
		$setting=$this->site->get_setting();
		$biller=$this->site->getAllBiller();
		$employee=$this->site->getAllEmployee();
		$all_unit=$this->site->getUnits();
		$product=$this->products_model->getProductName_code();
		$getGLChart=$this->products_model->getGLChart();
        $this->data['getGLChart'] = $getGLChart; 
        $this->data['AllUsers'] = $AllUsers; 
        $this->data['CurrentUser'] = $CurrentUser; 
        $this->data['setting'] = $setting; 
        $this->data['biller'] = $biller; 
        $this->data['all_unit'] = $all_unit; 
        $this->data['employees'] = $employee; 
        $this->data['product'] = $product; 
        $this->data['productJSON'] = json_encode($product); 
		$this->data['reference'] = $this->site->getReference('es');
		
		$this->data['modal_js'] = $this->site->modal_js();
		
		$this->data['enter_using_stock']=$this->products_model->getReferno();
		
		$this->data['empno']=$this->products_model->getEmpno();
		
		 $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('enter_using_stock')));
        $meta = array('page_title' => lang('enter_using_stock'), 'bc' => $bc);
        $this->page_construct('products/view_using_stock', $meta,$this->data);
		
	}
	function datatable_using_stock()
    {
        $this->load->library('datatables');
		
		$fdate=$this->input->get('fdate');
		$tdate=$this->input->get('tdate');
		
		$referno=$this->input->get('referno');
		$empno=$this->input->get('empno');
		//if($fdate=='' && $tdate==''){
		$start_date = $this->erp->fld($fdate);
        $end_date = $this->erp->fld($tdate);
		
        $this->datatables
            ->select("erp_enter_using_stock.id as id,erp_enter_using_stock.reference_no as refno,
			erp_companies.company,erp_warehouses.name as warehouse_name,erp_users.username,erp_enter_using_stock.note,
			erp_enter_using_stock.type as type,erp_enter_using_stock.date,erp_enter_using_stock.total_cost", FALSE)
            ->from("erp_enter_using_stock")
			
		    ->join('erp_companies', 'erp_companies.id=erp_enter_using_stock.shop', 'inner')
		    ->join('erp_warehouses', 'erp_enter_using_stock.warehouse_id=erp_warehouses.id', 'left')
			
			->join('erp_users', 'erp_users.id=erp_enter_using_stock.employee_id', 'inner');
			if($fdate!='' && $tdate!=''){
				$this->datatables->where('erp_enter_using_stock.date>=',$start_date);
				$this->datatables->where('erp_enter_using_stock.date<=',$end_date);
			}
			if($referno!=''){
				$this->datatables->where('erp_enter_using_stock.reference_no',$referno);
			}
			if($empno!=''){
				$this->datatables->where('erp_users.username',$empno);
			}
             $this->datatables->add_column("Actions", "<div class=\"text-center\">
			 <a class='edit_using' href='" . site_url('products/edit_enter_using_stock_by_id/$1/$2') . "'  class='tip' title='Edit'>
			 <i class=\"fa fa-edit\"></i>
			 </a>  
			 <a class='edit_return' href='" . site_url('products/edit_enter_using_stock_return_by_id/$1/$2') . "'  class='tip' title='Edit'>
			 <i class=\"fa fa-edit\"></i>
			 </a> 
			 <a href='" . site_url('products/print_enter_using_stock_by_id/$1/$2') . "'  class='tip' title='Print'>
			 <i class=\"fa fa-file-text-o\"></i>
			 </a> 
			 <a class='add_return' href='".site_url('products/return_enter_using_stock_by_id/$1') . "'  class='tip' title='Return'><i class=\"fa fa-reply\"></i></a>
			 ", "id,type");
			/* <a href='" . site_url('system_settings/edit_sale_type/$1') . "' data-toggle='modal' data-target='#myModal' class='tip' title='Edit'>
			 <i class=\"fa fa-edit\"></i>
			 </a> 
			 <a href='#' class='tip po' title='<b>" . lang("delete") . "</b>' data-content=\"<p>" . lang('r_u_sure') . "</p>
			 <a class='btn btn-danger po-delete' href='" . site_url('system_settings/delete_unit_of_saletype/$1') . "'>" . lang('i_m_sure') . "
			 </a> <button class='btn po-close'>" . lang('no') . "</button>\"  rel='popover'><i class=\"fa fa-trash-o\"></i>
			 </a>
			 </div>", "id,type");
			 */
        echo $this->datatables->generate();
    }
	function edit_enter_using_stock_by_id($id=NULL,$type=NULL){
		$this->erp->checkPermissions('adjustments');
        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['warehouses'] = $this->site->getAllWarehouses();
		$AllUsers=$this->site->getAllUsers();
		$CurrentUser=$this->site->getUser();
		$setting=$this->site->get_setting();
		$biller=$this->site->getAllBiller();
		$employee=$this->site->getAllEmployee();
		$all_unit=$this->site->getUnits();
		$product=$this->products_model->getProductName_code();
		$getGLChart=$this->products_model->getGLChart();
        $this->data['getGLChart'] = $getGLChart; 
        $this->data['AllUsers'] = $AllUsers; 
        $this->data['CurrentUser'] = $CurrentUser; 
        $this->data['setting'] = $setting; 
        $this->data['biller'] = $biller; 
        $this->data['all_unit'] = $all_unit; 
        $this->data['employees'] = $employee; 
        $this->data['product'] = $product; 
        $this->data['productJSON'] = json_encode($product); 
		$this->data['reference'] = $this->site->getReference('es');
		

		$getUsingStock=$this->products_model->getUsingStockById($id);
		$reference_no= $getUsingStock->reference_no;
		
		$wh_id=$getUsingStock->warehouse_id;
		$getUsingStockItem=$this->products_model->getUsingStockItemByRef($reference_no,$wh_id);
		
		$getQtyOnHandGroupByWh_ID=$this->products_model->getQtyOnHandGroupByWhID();
		
		$unit_of_measure_by_code=array();
		$i=0;
		foreach($getUsingStockItem as $Stock_I){
			$get_unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($Stock_I->product_code);
			foreach($get_unit_of_measure as $um){
				$product_code=$Stock_I->product_code;
				$u_description=$um->description;
				$u_measure_qty=$um->measure_qty;
				$unit_of_measure_by_code[$i]=array(
							'product_code'=>$product_code,
							'description'=>$u_description,
							'measure_qty'=>$u_measure_qty
				);
				$i++;
			}
		}
		//$this->erp->print_arrays($unit_of_measure_by_code);
		$this->data['unit_of_measure_by_code'] =$unit_of_measure_by_code;
		
		$this->data['qqh'] =$getQtyOnHandGroupByWh_ID;
		$this->data['stock'] =$getUsingStock;
		$this->data['stock_item'] =$getUsingStockItem;
		
		$this->data['modal_js'] = $this->site->modal_js();
		//$this->erp->print_arrays($data);
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('edit_enter_using_stock')));
        $meta = array('page_title' => lang('edit_enter_using_stock'), 'bc' => $bc);
        $this->page_construct('products/edit_enter_using_stock', $meta, $this->data);
	}
	public function update_enter_using_stock(){
			$stock_id			 =	$this->input->post('stock_id');
            $date 				 =	$this->erp->fld(trim($this->input->post('date')));
			$warehouse_id 	 = $this->input->post('from_location');
			$authorize_id 	 = $this->input->post('authorize_id');
			$employee_id 	 = $this->input->post('employee_id');
			$shop 	 			 = $this->input->post('shop');
			$account 	 		 = $this->input->post('account');
			$note 	 			 = $this->input->post('note');
			$cost 	 			 = $this->input->post('cost');
			
			$ref_prefix 	 			 = $this->input->post('ref_prefix');

			$stock_item_id_arr 	 			= $this->input->post('stock_item_id');
			$item_code_arr 	 				= $this->input->post('item_code');
			$description_arr 	 			 	= $this->input->post('description');
			$reason_arr 	 			 		= $this->input->post('reason');
			$qty_use_arr 	 			 		= $this->input->post('qty_use');
			$last_qty_use_arr 	 			= $this->input->post('last_qty_use');
			$unit_arr 	 			 		= $this->input->post('unit');
			$qty_arr  = $this->input->post('qty_use');
			$reference_no=$this->input->post('reference_no');
			
			$sotre_delete_id=$this->input->post('sotre_delete_id');
			
			$delete_item = (explode("-",$sotre_delete_id));

			$total_item_cost =0;
			$i=0;
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				$total_cost=$cost[$i]*$convert_qty;
				$total_item_cost+=$total_cost;
				//echo $qty_arr[$i].' * '.$total_cost.'='.$total_item_cost.'<br/>';
				$i++;
			}
			$CurrentUser=$this->site->getUser();
			$data = array(
				'date' => $date,
				'warehouse_id' => $warehouse_id,
				'authorize_id' => $authorize_id,
				'employee_id' => $employee_id,
				'shop' => $shop,
				'account' => $account,
				'note' => $note,
				'create_by' => $CurrentUser->id,
				'type' => 'use',
				'total_cost' =>	$total_item_cost,
			);
			$insert_enter_using_stock=$this->products_model->update_enter_using_stock($data,$ref_prefix,$stock_id);
			
			$i = 0;
			
			
			$del_pu_item= $this->products_model->delete_purchase_items_by_ref($reference_no);
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				
				if($stock_item_id_arr[$i]!="NULL"){
					$item_data = array(
								'code' => $item_code_arr[$i],
								'description' => $description_arr[$i],
								'reason' => $reason_arr[$i],
								'qty_use' => $convert_qty,
								'qty_by_unit' => $qty_use_arr[$i],
								'unit' => $unit_arr[$i],
								'warehouse_id' => $warehouse_id,
							);
					$insert_enter_using_stock_item=$this->products_model->update_enter_using_stock_item($item_data,$stock_item_id_arr[$i]);
					if($insert_enter_using_stock_item){
						$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
						$product_id=$product->id;
						$product_code=$product->code;
						$product_name=$product->name;
						$net_unit_cost=$product->price;
						$pur_data = array(
							'product_id' => $product_id,
							'product_code' => $product_code,
							'product_name' => $product_name,
							'net_unit_cost' => $product->cost,
							'option_id' => $unit_of_measure->id,
							'quantity' => -1*abs($convert_qty),
							'warehouse_id' => $warehouse_id,
							'subtotal' => $pr_item->subtotal?$pr_item->subtotal:0,
							'date' => $date,
							'status' => '',
							'reference'=>$reference_no,
							'net_unit_cost' => $net_unit_cost,
							'quantity_balance' => -1*abs($convert_qty)
						);
						$this->db->insert('purchase_items', $pur_data);
						$this->site->syncProductQty($product_id, $warehouse_id);
					}
				}else{
				//echo $stock_item_id_arr[$i];
					$item_data = array(
								'code' => $item_code_arr[$i],
								'description' => $description_arr[$i],
								'reason' => $reason_arr[$i],
								'qty_use' => $convert_qty,
								'unit' => $unit_arr[$i],
								'warehouse_id' => $warehouse_id,
								'reference_no' => $reference_no,
							);
					//print_r($item_data);		
					//echo '||||| <br/>';
					$insert_enter_using_stock_item=$this->products_model->insert_enter_using_stock_item($item_data);
					if($insert_enter_using_stock_item){
						$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
						$product_id=$product->id;
						$product_code=$product->code;
						$product_name=$product->name;
						$net_unit_cost=$product->price;
						$this->site->syncProductQty($product_id, $warehouse_id);
					}
					
				}
						$i++;	
			}
			foreach($delete_item as $d_i){
				$del=$this->products_model->delete_update_stock_item($d_i);
			}
			if($insert_enter_using_stock_item && $insert_enter_using_stock){
				$this->session->set_flashdata(lang('enter_using_stock_added.'));
					$r_r=str_replace("/","-",$this->input->post('reference_no'));
					
                    redirect('products/print_enter_using_stock/'.$r_r);
			}else{
				$this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
			}
		
	}
	function print_enter_using_stock_by_id($id,$type)
    {
		$this->erp->checkPermissions('using_stock');
		if($type=="use"){
			$using_stock=$this->products_model->get_enter_using_stock_by_id($id);
			$ref_no=$using_stock->reference_no;
			$stock_item=$this->products_model->get_enter_using_stock_item_by_ref($ref_no);
			 $this->data['using_stock'] = $using_stock; 
			 $this->data['stock_item'] = $stock_item; 
			$this->load->view($this->theme.'products/print_enter_using_stock',$this->data);
		}
		if($type=="return"){
			$using_stock=$this->products_model->get_enter_using_stock_by_id($id);
			$ref_no=$using_stock->reference_no;
			$stock_item=$this->products_model->get_enter_using_stock_item_by_ref($ref_no);
			 $this->data['using_stock'] = $using_stock; 
			 $this->data['stock_item'] = $stock_item; 
			$this->load->view($this->theme.'products/print_enter_using_stock_return',$this->data);
		}
    }
	function return_enter_using_stock_by_id($id=NULL,$type=NULL){
		$this->erp->checkPermissions('adjustments');
        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['warehouses'] = $this->site->getAllWarehouses();
		$AllUsers=$this->site->getAllUsers();
		$CurrentUser=$this->site->getUser();
		$setting=$this->site->get_setting();
		$biller=$this->site->getAllBiller();
		$employee=$this->site->getAllEmployee();
		$all_unit=$this->site->getUnits();
		$product=$this->products_model->getProductName_code();
		$getGLChart=$this->products_model->getGLChart();
        $this->data['getGLChart'] = $getGLChart; 
        $this->data['AllUsers'] = $AllUsers; 
        $this->data['CurrentUser'] = $CurrentUser; 
        $this->data['setting'] = $setting; 
        $this->data['biller'] = $biller; 
        $this->data['all_unit'] = $all_unit; 
        $this->data['employees'] = $employee; 
        $this->data['product'] = $product; 
        $this->data['productJSON'] = json_encode($product); 
		$this->data['reference'] = $this->site->getReference('es');
		

		$getUsingStock=$this->products_model->getUsingStockById($id);
		$reference_no= $getUsingStock->reference_no;
		
		$wh_id=$getUsingStock->warehouse_id;
		$getUsingStockItem=$this->products_model->getUsingStockItemByRef($reference_no,$wh_id);
		
		$getQtyOnHandGroupByWh_ID=$this->products_model->getQtyOnHandGroupByWhID();
		
		$unit_of_measure_by_code=array();
		$i=0;
		foreach($getUsingStockItem as $Stock_I){
			$get_unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($Stock_I->product_code);
			foreach($get_unit_of_measure as $um){
				$product_code=$Stock_I->product_code;
				$u_description=$um->description;
				$u_measure_qty=$um->measure_qty;
				$unit_of_measure_by_code[$i]=array(
							'product_code'=>$product_code,
							'description'=>$u_description,
							'measure_qty'=>$u_measure_qty
				);
				$i++;
			}
		}
		//$this->erp->print_arrays($unit_of_measure_by_code);
		$this->data['unit_of_measure_by_code'] =$unit_of_measure_by_code;
		$return_ref = $this->products_model->getReturnReference($reference_no);
		$this->data['reference_no'] = $return_ref;
		$this->data['qqh'] = $getQtyOnHandGroupByWh_ID;
		$this->data['stock'] = $getUsingStock;
		$this->data['stock_item'] =$getUsingStockItem;
		
		$this->data['reference_return'] = $this->site->getReference('esr');
		$this->data['modal_js'] = $this->site->modal_js();
		//$this->erp->print_arrays($data);
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('return_using_stock')));
        $meta = array('page_title' => lang('return_using_stock'), 'bc' => $bc);
        $this->page_construct('products/return_enter_using_stock', $meta, $this->data);
	}
	public function add_enter_using_stock_return(){

            $date = $this->erp->fld(trim($this->input->post('date')));
			$reference_no 	     = $this->input->post('reference_no');
			$return_reference_no = $this->input->post('return_reference_no');
			$warehouse_id 	 	 = $this->input->post('from_location');
			$authorize_id 	  	 = $this->input->post('authorize_id');
			$employee_id 	 	 = $this->input->post('employee_id');
			$shop 	 			 = $this->input->post('shop');
			$account 	 		 = $this->input->post('account');
			$note 	 			 = $this->input->post('note');
			$cost 	 			 = $this->input->post('cost');
			$total_cost_by_row 	 = $this->input->post('total_cost');
			$ref_prefix 	 	 = $this->input->post('ref_prefix');
			$item_code_arr 	 	 = $this->input->post('item_code');
			$description_arr 	 = $this->input->post('description');
			$reason_arr 	 	 = $this->input->post('reason');
			$qty_use_arr 	 	 = $this->input->post('qty_use');
			$qty_return_arr 	 = $this->input->post('qty_return');
			$unit_arr 	 		 = $this->input->post('unit');
			$qty_arr  			 = $this->input->post('qty_use');
			$total_item_cost 	 = 0;
			//print_r($total_cost_by_row);
			//echo '///<br/>';
			//echo 'New _ cost __________________<br/>';
			$i=0;
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$convert_cost=($cost[$i]*$unit_of_measure->measure_qty)*$qty_return_arr[$i];
				$total_cost=$convert_cost*$qty_return_arr[$i];
				$total_item_cost+=$convert_cost;
				//echo $total_item_cost.'<br/>';
				$i++;
			}
			//echo 'Old _ cost __________________<br/>';
			$i=0;
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$old_product_cost=$this->products_model->getUsingStockItem($item_code_arr[$i],$reference_no);
				$total_old_cost=$old_product_cost->cost * $qty_return_arr[$i];
				$convert_cost=$total_old_cost*$unit_of_measure->measure_qty;
				$total_cost=$convert_cost*$qty_return_arr[$i];
				$total_old_item_cost+=$convert_cost;
				//echo $total_old_item_cost.'<br/>';
				$i++;
			}//exit;
			$CurrentUser=$this->site->getUser();
			$data = array(
				'date' => $date,
				'using_reference_no' => $reference_no,
				'reference_no' => $return_reference_no,
				'warehouse_id' => $warehouse_id,
				'authorize_id' => $authorize_id,
				'employee_id' => $employee_id,
				'shop' => $shop,
				'account' => $account,
				'note' => $note,
				'create_by' => $CurrentUser->id,
				'type' => 'return',
				'total_cost' =>	$total_item_cost,
				'total_using_cost' =>	$total_old_item_cost,
			);
			//print_r($data);exit;
			$insert_enter_using_stock=$this->products_model->insert_enter_using_stock($data,$ref_prefix);
			
			
			$i = 0;
			foreach($item_code_arr as $item_code){
					$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
					$getProduct = $this->products_model->getProductByCode($item_code_arr[$i]);
					$convert_qty=$qty_return_arr[$i]*$unit_of_measure->measure_qty;
					$cost=$getProduct->cost;
					$item_data = array(
								'code' => $item_code_arr[$i],
								'description' => $description_arr[$i],
								'reason' => $reason_arr[$i],
								'qty_use' => $convert_qty,
								'qty_by_unit' => $qty_return_arr[$i],
								'unit' => $unit_arr[$i],
								'cost' => $cost,
								'warehouse_id' => $warehouse_id,
								'reference_no' => $return_reference_no,
							);
						$insert_enter_using_stock_item=$this->products_model->insert_enter_using_stock_item($item_data);
						if($insert_enter_using_stock_item){
						$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
						$product_id=$product->id;
						$product_code=$product->code;
						$product_name=$product->name;
						$net_unit_cost=$product->price;
						$pur_data = array(
							'product_id' => $product_id,
							'product_code' => $product_code,
							'product_name' => $product_name,
							'net_unit_cost' => $product->cost,
							'option_id' => $unit_of_measure->id,
							'quantity' => abs($convert_qty),
							'net_unit_cost' => $net_unit_cost,
							'warehouse_id' => $warehouse_id,
							'subtotal' => $pr_item->subtotal?$pr_item->subtotal:0,
							'date' => $date,
							'reference' => $return_reference_no,
							'status' => '',
							'quantity_balance' => abs($convert_qty)
						);
						$this->db->insert('purchase_items', $pur_data);
						$this->site->syncProductQty($product_id, $warehouse_id);
					}	
						$i++;	
			}		
			if($insert_enter_using_stock_item && $insert_enter_using_stock){
				$this->session->set_flashdata(lang('enter_using_stock_return_added.'));
					$r_r=str_replace("/","-",$return_reference_no);
					
                    redirect('products/print_enter_using_stock_return/'.$r_r);
			}else{
				$this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
			}
		
	}
	function print_enter_using_stock_return($ref)
    {
		$r_r=str_replace("-","/",$ref);
        $using_stock=$this->products_model->get_enter_using_stock_by_ref($r_r);
        $stock_item=$this->products_model->get_enter_using_stock_item_by_ref($r_r);
		 $this->data['using_stock'] = $using_stock; 
		 $this->data['stock_item'] = $stock_item; 
        $this->load->view($this->theme.'products/print_enter_using_stock_return',$this->data);
    }
	public function edit_enter_using_stock_return_by_id($id,$type){
		$this->erp->checkPermissions('adjustments');
        $data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        $this->data['warehouses'] = $this->site->getAllWarehouses();
		$AllUsers=$this->site->getAllUsers();
		$CurrentUser=$this->site->getUser();
		$setting=$this->site->get_setting();
		$biller=$this->site->getAllBiller();
		$employee=$this->site->getAllEmployee();
		$all_unit=$this->site->getUnits();
		$product=$this->products_model->getProductName_code();
		$getGLChart=$this->products_model->getGLChart();
        $this->data['getGLChart'] = $getGLChart; 
        $this->data['AllUsers'] = $AllUsers; 
        $this->data['CurrentUser'] = $CurrentUser; 
        $this->data['setting'] = $setting; 
        $this->data['biller'] = $biller; 
        $this->data['all_unit'] = $all_unit; 
        $this->data['employees'] = $employee; 
        $this->data['product'] = $product; 
        $this->data['productJSON'] = json_encode($product); 
		$this->data['reference'] = $this->site->getReference('es');
		

		$getUsingStock=$this->products_model->getUsingStockById($id);
		$reference_no= $getUsingStock->reference_no;
		
		$wh_id=$getUsingStock->warehouse_id;
		$getUsingStockItem=$this->products_model->getUsingStockReturnItemByRef($reference_no,$wh_id);
		
		$getQtyOnHandGroupByWh_ID=$this->products_model->getQtyOnHandGroupByWhID();
		
		$unit_of_measure_by_code=array();
		$i=0;
		foreach($getUsingStockItem as $Stock_I){
			$get_unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($Stock_I->product_code);
			foreach($get_unit_of_measure as $um){
				$product_code=$Stock_I->product_code;
				$u_description=$um->description;
				$u_measure_qty=$um->measure_qty;
				$unit_of_measure_by_code[$i]=array(
							'product_code'=>$product_code,
							'description'=>$u_description,
							'measure_qty'=>$u_measure_qty
				);
				$i++;
			}
		}
		//$this->erp->print_arrays($unit_of_measure_by_code);
		$this->data['unit_of_measure_by_code'] =$unit_of_measure_by_code;
		
		$this->data['qqh'] =$getQtyOnHandGroupByWh_ID;
		$this->data['stock'] =$getUsingStock;
		$this->data['stock_item'] =$getUsingStockItem;
		
		$this->data['modal_js'] = $this->site->modal_js();
		//$this->erp->print_arrays($data);
        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('edit_enter_using_stock_return')));
        $meta = array('page_title' => lang('edit_enter_using_stock_return'), 'bc' => $bc);
        $this->page_construct('products/edit_enter_using_stock_return', $meta, $this->data);
	}
	public function update_enter_using_stock_return_by_id(){
			$stock_id			 =	$this->input->post('stock_id');
            $date 				 =	$this->erp->fld(trim($this->input->post('date')));
			$warehouse_id 	 = $this->input->post('from_location');
			$authorize_id 	 = $this->input->post('authorize_id');
			$employee_id 	 = $this->input->post('employee_id');
			$shop 	 			 = $this->input->post('shop');
			$account 	 		 = $this->input->post('account');
			$note 	 			 = $this->input->post('note');
			$cost 	 			 = $this->input->post('cost');
			
			$ref_prefix 	 			 = $this->input->post('ref_prefix');

			$stock_item_id_arr 	 			= $this->input->post('stock_item_id');
			$item_code_arr 	 				= $this->input->post('item_code');
			$description_arr 	 			 	= $this->input->post('description');
			$reason_arr 	 			 		= $this->input->post('reason');
			$qty_use_arr 	 			 		= $this->input->post('qty_return');
			$last_qty_use_arr 	 			= $this->input->post('last_qty_return');
			$unit_arr 	 			 		= $this->input->post('unit');
			$qty_arr  = $this->input->post('qty_use');
			$reference_no=$this->input->post('reference_no');
			
			$sotre_delete_id=$this->input->post('sotre_delete_id');
			
			$delete_item = (explode("-",$sotre_delete_id));

			$total_item_cost =0;
			$using_reference_no=$this->input->post('using_reference_no');
				$i=0;
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				$total_cost=$cost[$i]*$convert_qty;
				$total_item_cost+=$total_cost;
				
				$i++;
			}
			//echo $total_item_cost.'<br/>';
				$i=0;
				$total_old_item_cost=0;
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$old_product_cost=$this->products_model->getUsingStockItem($item_code_arr[$i],$using_reference_no);
				$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				$total_cost=$old_product_cost->cost*$convert_qty;
				$total_old_item_cost+=$total_cost;
				
				$i++;
			}
			//echo $total_old_item_cost.'<br/>';
			//exit;
			$CurrentUser=$this->site->getUser();
			$data = array(
				'date' => $date,
				'warehouse_id' => $warehouse_id,
				'authorize_id' => $authorize_id,
				'employee_id' => $employee_id,
				'shop' => $shop,
				'account' => $account,
				'note' => $note,
				'create_by' => $CurrentUser->id,
				'type' => 'return',
				'total_cost' =>	$total_item_cost,
				'total_using_cost' =>	$total_old_item_cost,
			);
			$insert_enter_using_stock=$this->products_model->update_enter_using_stock($data,$ref_prefix,$stock_id);
			
			$i = 0;
			
			
			$del_pu_item= $this->products_model->delete_purchase_items_by_ref($reference_no);
			foreach($item_code_arr as $item_code){
				$unit_of_measure=$this->products_model->getUnitOfMeasureByProductCode($item_code_arr[$i],$unit_arr[$i]);
				$convert_qty=$qty_use_arr[$i]*$unit_of_measure->measure_qty;
				
				if($stock_item_id_arr[$i]!="NULL"){
					$item_data = array(
								'code' => $item_code_arr[$i],
								'description' => $description_arr[$i],
								'reason' => $reason_arr[$i],
								'qty_use' => $convert_qty,
								'qty_by_unit' => $qty_use_arr[$i],
								'unit' => $unit_arr[$i],
								'warehouse_id' => $warehouse_id,
							);
					$insert_enter_using_stock_item=$this->products_model->update_enter_using_stock_item($item_data,$stock_item_id_arr[$i]);
					if($insert_enter_using_stock_item){
						$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
						$product_id=$product->id;
						$product_code=$product->code;
						$product_name=$product->name;
						$net_unit_cost=$product->price;
						$pur_data = array(
							'product_id' => $product_id,
							'product_code' => $product_code,
							'product_name' => $product_name,
							'net_unit_cost' => $product->cost,
							'option_id' => $unit_of_measure->id,
							'quantity' => $convert_qty,
							'warehouse_id' => $warehouse_id,
							'subtotal' => $pr_item->subtotal?$pr_item->subtotal:0,
							'date' => $date,
							'status' => '',
							'reference' => $reference_no,
							'net_unit_cost' => $net_unit_cost,
							'quantity_balance' =>$convert_qty
						);
						$this->db->insert('purchase_items', $pur_data);
						$this->site->syncProductQty($product_id, $warehouse_id);
					}
				}else{
				//echo $stock_item_id_arr[$i];
					$item_data = array(
								'code' => $item_code_arr[$i],
								'description' => $description_arr[$i],
								'reason' => $reason_arr[$i],
								'qty_use' => $convert_qty,
								'unit' => $unit_arr[$i],
								'warehouse_id' => $warehouse_id,
							);
					//print_r($item_data);		
					//echo '||||| <br/>';
					$insert_enter_using_stock_item=$this->products_model->insert_enter_using_stock_item($item_data);
					if($insert_enter_using_stock_item){
						$product=$this->products_model->getProductQtyByCode($item_code_arr[$i]);
						$product_id=$product->id;
						$product_code=$product->code;
						$product_name=$product->name;
						$net_unit_cost=$product->price;
						$this->site->syncProductQty($product_id, $warehouse_id);
					}
					
				}
						$i++;	
			}
			foreach($delete_item as $d_i){
				$del=$this->products_model->delete_update_stock_item($d_i);
			}
			if($insert_enter_using_stock_item && $insert_enter_using_stock){
				$this->session->set_flashdata(lang('enter_using_stock_added.'));
					$r_r=str_replace("/","-",$this->input->post('reference_no'));
					
                    redirect('products/print_enter_using_stock/'.$r_r);
			}else{
				$this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
			}
		
	}
	public function export_using_stock_to_excel(){
                $this->load->library('excel');
                $this->excel->setActiveSheetIndex(0);
                $this->excel->getActiveSheet()->setTitle(lang('list_using_stock'));
                $this->excel->getActiveSheet()->SetCellValue('A1', lang('id'));
                $this->excel->getActiveSheet()->SetCellValue('B1', lang('reference_no'));
                $this->excel->getActiveSheet()->SetCellValue('C1', lang('warehouse'));
                $this->excel->getActiveSheet()->SetCellValue('D1', lang('employee'));
                $this->excel->getActiveSheet()->SetCellValue('E1', lang('description'));
                $this->excel->getActiveSheet()->SetCellValue('F1', lang('status'));
                $this->excel->getActiveSheet()->SetCellValue('G1', lang('date'));
                $this->excel->getActiveSheet()->SetCellValue('H1', lang('cost'));
				
			$using_stock=$this->products_model->get_all_enter_using_stock();
			$i=2;
			foreach($using_stock as $row){
				//$ref_no=$row->reference_no;
				//$stock_item=$this->products_model->get_enter_using_stock_item_by_ref($ref_no);
				$this->excel->getActiveSheet()->SetCellValue('A'.$i, $row->id);
				$this->excel->getActiveSheet()->SetCellValue('B'.$i, $row->reference_no);
				$this->excel->getActiveSheet()->SetCellValue('C'.$i, $row->warehouse_name);
				$this->excel->getActiveSheet()->SetCellValue('D'.$i, $row->first_name.' '.$row->first_name);
				$this->excel->getActiveSheet()->SetCellValue('E'.$i, $row->note);
				$this->excel->getActiveSheet()->SetCellValue('F'.$i, $row->type);
				$this->excel->getActiveSheet()->SetCellValue('G'.$i, $row->date);
				$this->excel->getActiveSheet()->SetCellValue('H'.$i, $row->total_cost);
				$i++;
				
				
			}

                $this->excel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('B')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('E')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('G')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('H')->setWidth(20);
                $this->excel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
                $filename = lang('list_using_stock');
                $this->excel->getDefaultStyle()->getAlignment()->setVertical(PHPExcel_Style_Alignment::VERTICAL_CENTER);
                    ob_clean();
                    header('Content-Type: application/vnd.ms-excel');
                    header('Content-Disposition: attachment;filename="' . $filename . '.xls"');
                    header('Cache-Control: max-age=0');
                    ob_clean();
                    $objWriter = PHPExcel_IOFactory::createWriter($this->excel, 'Excel5');
                    $objWriter->save('php://output');
                    exit();
	}

	public function stock_count()
	{
        $this->erp->checkPermissions('stock_count');
		$this->data['warehouses'] = $this->site->getAllWarehouses();
		$this->data['category']   = $this->site->getAllCategories();
		$bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('sales'), 'page' => lang('sales')), array('link' => '#', 'page' => lang('stock_count')));
		$meta = array('page_title' => lang('stock_count'), 'bc' => $bc);
		$this->page_construct('products/stock_count', $meta, $this->data);
    }
	
	public function exportStock()
	{
		$arrPro = $_REQUEST['pro_id'];
		$arrQty = $_REQUEST['pro_qty'];
		$wareId = $_REQUEST['warehouse_id'];
		$cateId = $_REQUEST['category_id'];
		$final = array_combine($arrPro, $arrQty);
		$all_product = $this->products_model->getProductByWareId($wareId, $cateId);
		foreach($all_product as $pro_all){
			$pro_all->qty = $final[$pro_all->pid]?$final[$pro_all->pid]:0;
			$pro_count[] = $pro_all;
		}
		echo json_encode($pro_count);
	}
	
	public function stock_count_excel(){
		$t = $this->input->get('excel');
		echo json_encode($t);
	}
	
	
	function stock_counts($warehouse_id = NULL)
    {
        $this->erp->checkPermissions('stock_count');

        $this->data['error'] = (validation_errors()) ? validation_errors() : $this->session->flashdata('error');
        if ($this->Owner || $this->Admin || !$this->session->userdata('warehouse_id')) {
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['warehouse_id'] = $warehouse_id;
            $this->data['warehouse'] = $warehouse_id ? $this->site->getWarehouseByID($warehouse_id) : NULL;
        } else {
            $this->data['warehouses'] = NULL;
            $this->data['warehouse_id'] = $this->session->userdata('warehouse_id');
            $this->data['warehouse'] = $this->session->userdata('warehouse_id') ? $this->site->getWarehouseByID($this->session->userdata('warehouse_id')) : NULL;
        }

        $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('stock_counts')));
        $meta = array('page_title' => lang('stock_counts'), 'bc' => $bc);
        $this->page_construct('products/stock_counts', $meta, $this->data);
    }
	
	function getCounts($warehouse_id = NULL)
    {
        $this->erp->checkPermissions('stock_count', TRUE);

        if ((! $this->Owner || ! $this->Admin) && ! $warehouse_id) {
            $user = $this->site->getUser();
            $warehouse_id = $user->warehouse_id;
        }
        $detail_link = anchor('products/view_count/$1', '<label class="label label-primary pointer">'.lang('details').'</label>', 'class="tip" title="'.lang('details').'" data-toggle="modal" data-target="#myModal"');

        $this->load->library('datatables');
        $this->datatables
            ->select("{$this->db->dbprefix('stock_counts')}.id as id, date, reference_no, {$this->db->dbprefix('warehouses')}.name as wh_name, type, brand_names, category_names, initial_file, final_file")
            ->from('stock_counts')
            ->join('warehouses', 'warehouses.id=stock_counts.warehouse_id', 'left');
        if ($warehouse_id) {
            $this->datatables->where('warehouse_id', $warehouse_id);
        }

        $this->datatables->add_column('Actions', '<div class="text-center">'.$detail_link.'</div>', "id");
        echo $this->datatables->generate();
    }
	
	function view_count($id)
    {
        $this->erp->checkPermissions('stock_count', TRUE);
        $stock_count = $this->products_model->getStouckCountByID($id);
		
        if ( ! $stock_count->finalized ) {
            $this->erp->md('products/finalize_count/'.$id);
        }

        $this->data['stock_count'] = $stock_count;
        $this->data['stock_count_items'] = $this->products_model->getStockCountItems($id);
        $this->data['warehouse'] = $this->site->getWarehouseByID($stock_count->warehouse_id);
        $this->data['adjustment'] = $this->products_model->getAdjustmentByCountID($id);
		
        $this->load->view($this->theme.'products/view_count', $this->data);
    }

    function count_stock($page = NULL)
    {
        $this->erp->checkPermissions('stock_count');
        $this->form_validation->set_rules('warehouse', lang("warehouse"), 'required');
        $this->form_validation->set_rules('type', lang("type"), 'required');

        if ($this->form_validation->run() == true) {

            $warehouse_id = $this->input->post('warehouse');
            $type = $this->input->post('type');
            $categories = $this->input->post('category') ? $this->input->post('category') : NULL;
            $brands = $this->input->post('brand') ? $this->input->post('brand') : NULL;
            $this->load->helper('string');
            $name = random_string('md5').'.csv';
            $products = $this->products_model->getStockCountProducts($warehouse_id, $type, $categories, $brands);
            $pr = 0; $rw = 0;
            foreach ($products as $product) {
                if ($variants = $this->products_model->getStockCountProductVariants($warehouse_id, $product->id)) {
                    foreach ($variants as $variant) {
                        $items[] = array(
                            'product_code' => $product->code,
                            'product_name' => $product->name,
                            'variant' => $variant->name,
                            'expected' => $variant->quantity,
                            'counted' => ''
                            );
                        $rw++;
                    }
                } else {
                    $items[] = array(
                        'product_code' => $product->code,
                        'product_name' => $product->name,
                        'variant' => '',
                        'expected' => $product->quantity,
                        'counted' => ''
                        );
                    $rw++;
                }
                $pr++;
            }
            if ( ! empty($items)) {
                $csv_file = fopen('./files/'.$name, 'w');
                fputcsv($csv_file, array(lang('product_code'), lang('product_name'), lang('variant'), lang('expected'), lang('counted')));
                foreach ($items as $item) {
                    fputcsv($csv_file, $item);
                }
                // file_put_contents('./files/'.$name, $csv_file);
                // fwrite($csv_file, $txt);
                fclose($csv_file);
            } else {
                $this->session->set_flashdata('error', lang('no_product_found'));
                redirect($_SERVER["HTTP_REFERER"]);
            }

            if ($this->Owner || $this->Admin) {
                $date = $this->erp->fld($this->input->post('date'));
            } else {
                $date = date('Y-m-d H:s:i');
            }
            $category_ids = '';
            $brand_ids = '';
            $category_names = '';
            $brand_names = '';
            if ($categories) {
                $r = 1; $s = sizeof($categories);
                foreach ($categories as $category_id) {
                    $category = $this->site->getCategoryByID($category_id);
                    if ($r == $s) {
                        $category_names .= $category->name;
                        $category_ids .= $category->id;
                    } else {
                        $category_names .= $category->name.', ';
                        $category_ids .= $category->id.', ';
                    }
                    $r++;
                }
            }
            if ($brands) {
                $r = 1; $s = sizeof($brands);
                foreach ($brands as $brand_id) {
                    $brand = $this->site->getBrandByID($brand_id);
                    if ($r == $s) {
                        $brand_names .= $brand->name;
                        $brand_ids .= $brand->id;
                    } else {
                        $brand_names .= $brand->name.', ';
                        $brand_ids .= $brand->id.', ';
                    }
                    $r++;
                }
            }
            $data = array(
                'date' => $date,
                'warehouse_id' => $warehouse_id,
                'reference_no' => $this->input->post('reference_no'),
                'type' => $type,
                'categories' => $category_ids,
                'category_names' => $category_names,
                'brands' => $brand_ids,
                'brand_names' => $brand_names,
                'initial_file' => $name,
                'products' => $pr,
                'rows' => $rw,
                'created_by' => $this->session->userdata('user_id')
            );

        }
        
        if ($this->form_validation->run() == true && $this->products_model->addStockCount($data)) {
            $this->session->set_flashdata('message', lang("stock_count_intiated"));
            redirect('products/stock_counts');

        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['warehouses'] = $this->site->getAllWarehouses();
            $this->data['categories'] = $this->site->getAllCategories();
            $this->data['brands'] = $this->site->getAllBrands();
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => '#', 'page' => lang('count_stock')));
            $meta = array('page_title' => lang('count_stock'), 'bc' => $bc);
            $this->page_construct('products/count_stock', $meta, $this->data);
		
		}

    }

    function finalize_count($id)
    {
        $this->erp->checkPermissions('stock_count');
        $stock_count = $this->products_model->getStouckCountByID($id);
        if ( ! $stock_count || $stock_count->finalized) {
            $this->session->set_flashdata('error', lang("stock_count_finalized"));
            redirect('products/stock_counts');
        }

        $this->form_validation->set_rules('count_id', lang("count_stock"), 'required');

        if ($this->form_validation->run() == true) {

            if ($_FILES['csv_file']['size'] > 0) {
                $note = $this->erp->clear_tags($this->input->post('note'));
                $data = array(
                    'updated_by' => $this->session->userdata('user_id'),
                    'updated_at' => date('Y-m-d H:s:i'),
                    'note' => $note
                );

                $this->load->library('upload');
                $config['upload_path'] = $this->digital_upload_path;
                $config['allowed_types'] = 'csv';
                $config['max_size'] = $this->allowed_file_size;
                $config['overwrite'] = false;
                $config['encrypt_name'] = true;
                $this->upload->initialize($config);
                if (!$this->upload->do_upload('csv_file')) {
                    $error = $this->upload->display_errors();
                    $this->session->set_flashdata('error', $error);
                    redirect($_SERVER["HTTP_REFERER"]);
                }

                $csv = $this->upload->file_name;

                $arrResult = array();
                $handle = fopen($this->digital_upload_path . $csv, "r");
                if ($handle) {
                    while (($row = fgetcsv($handle, 5000, ",")) !== FALSE) {
                        $arrResult[] = $row;
                    }
                    fclose($handle);
                }
                $titles = array_shift($arrResult);
                $keys = array('product_code', 'product_name', 'product_variant', 'expected', 'counted');
                $final = array();
                foreach ($arrResult as $key => $value) {
                    $final[] = array_combine($keys, $value);
                }
                //$this->erp->print_arrays($arrResult);
                $rw = 2; $differences = 0; $matches = 0;
                foreach ($final as $pr) {
                    if ($product = $this->products_model->getProductByCode(trim($pr['product_code']))) {
						$warehouse = $this->products_model->getWarehouseProduct($product->id);
                        $pr['counted'] = !empty($pr['counted']) ? $pr['counted'] : 0;
                        //if ($pr['expected'] == $pr['counted']) {
                          //  $matches++;
                        //} else {
							$pr['stock_count_id'] = $id;
                            $pr['product_id'] = $product->id;
                            $pr['cost'] = $product->cost;
                            $pr['product_variant_id'] = empty($pr['product_variant']) ? NULL : $this->products_model->getProductVariantID($pr['product_id'], $pr['product_variant']);
                            $products[] = $pr;
                            $differences++;
							
							//Adjust Stock
							if($pr['counted'] <> 0){
								$qty = (-1) * $pr['expected'];
								if($pr['expected'] == 0){
									$qty = 0;
								}
								if($qty <> 0){
									$ad_stock[] = array(
										'product_id' => $product->id,
										'product_code' => $pr['product_code'],
										'product_name' => $pr['product_name'],
										'option_id' => $pr['option_id'],
										'warehouse_id' => $warehouse->warehouse_id,
										'quantity_balance' => $qty
									);
								}
								
								$ad_stock[] = array(
									'product_id' => $product->id,
									'product_code' => $pr['product_code'],
									'product_name' => $pr['product_name'],
									'option_id' => $pr['option_id'],
									'warehouse_id' => $warehouse->warehouse_id,
									'quantity_balance' => $pr['counted']
								);
								$product_id[] = $product->id;
							}
                        //}
                    } else {
                        $this->session->set_flashdata('error', lang('check_product_code') . ' (' . $pr['product_code'] . '). ' . lang('product_code_x_exist') . ' ' . lang('line_no') . ' ' . $rw);
                        redirect('products/finalize_count/'.$id);
                    }
                    $rw++;
                }
				//$this->products_model->addStock($ad_stock, $product_id);
                $data['final_file'] = $csv;
                $data['differences'] = $differences;
                $data['matches'] = $matches;
                $data['missing'] = $stock_count->rows-($rw-2);
                $data['finalized'] = 1;
            }

            //$this->erp->print_arrays($data, $products);
        }
        
        if ($this->form_validation->run() == true && $this->products_model->finalizeStockCount($id, $data, $products)) {
            $this->session->set_flashdata('message', lang("stock_count_finalized"));
            redirect('products/stock_counts');
        } else {

            $this->data['error'] = (validation_errors() ? validation_errors() : $this->session->flashdata('error'));
            $this->data['stock_count'] = $stock_count;
            $this->data['warehouse'] = $this->site->getWarehouseByID($stock_count->warehouse_id);
            $bc = array(array('link' => base_url(), 'page' => lang('home')), array('link' => site_url('products'), 'page' => lang('products')), array('link' => site_url('products/stock_counts'), 'page' => lang('stock_counts')), array('link' => '#', 'page' => lang('finalize_count')));
            $meta = array('page_title' => lang('finalize_count'), 'bc' => $bc);
            $this->page_construct('products/finalize_count', $meta, $this->data);

        }

    }

}