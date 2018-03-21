<div class="modal-dialog modal-lg">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-2x">&times;</i>
            </button>
            <h4 class="modal-title" id="myModalLabel"><?php echo lang('edit_customer'); ?></h4>
        </div>
        <?php $attrib = array('data-toggle' => 'validator', 'role' => 'form');
        echo form_open_multipart("customers/edit/" . $customer->id, $attrib); ?>
        <div class="modal-body">
            <p><?= lang('enter_info'); ?></p>

            <div class="form-group">
                <label class="control-label"
                       for="customer_group"><?php echo $this->lang->line("default_customer_group"); ?></label>

                <div class="controls"> <?php
                    foreach ($customer_groups as $customer_group) {
                        $cgs[$customer_group->id] = $customer_group->name;
                    }
                    echo form_dropdown('customer_group', $cgs, $customer->customer_group_id, 'class="form-control tip select" id="customer_group" style="width:100%;" required="required"');
                    ?>
                </div>
            </div>
			
			<div class="form-group">
                <label class="control-label"
                       for="price_group"><?php echo $this->lang->line("price_groups"); ?></label>

                <div class="controls"> <?php
					$pr_group[""] = "No Price Group";
                    foreach ($price_groups as $price_group) {
                        $pr_group[$price_group->id] = $price_group->name;
                    }
                    echo form_dropdown('price_groups', $pr_group, $customer->price_group_id, 'class="form-control tip select" id="price_groups" style="width:100%;" placeholder="' . lang("select") . ' ' . lang("price_groups") . '" ');
                    ?>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
					<?php if($setting->show_company_code == 1) { ?>
					<div class="form-group">
                        <?= lang("code", "code"); ?>
                        <?php echo form_input('code', $customer->code, 'class="form-control tip" id="code"  data-bv-notempty="true"'); ?>
                    </div>
					<?php } ?>
                    <div class="form-group company">
                        <?= lang("company", "company"); ?>
                        <?php echo form_input('company', $customer->company, 'class="form-control tip" id="company" required="required"'); ?>
                    </div>
                    <div class="form-group person">
                        <?= lang("name", "name"); ?>
                        <?php echo form_input('name', $customer->name, 'class="form-control tip" id="name" required="required"'); ?>
                    </div>
                    <div class="form-group">
                        <?= lang("vat_no", "vat_no"); ?>
                        <?php echo form_input('vat_no', $customer->vat_no, 'class="form-control" id="vat_no"'); ?>
                    </div>
                    <!--<div class="form-group company">
                    <?= lang("contact_person", "contact_person"); ?>
                    <?php //echo form_input('contact_person', $customer->contact_person, 'class="form-control" id="contact_person" required="required"'); ?>
                </div> -->
                    <div class="form-group">
                        <?= lang("email_address", "email_address"); ?>
                        <input type="email" name="email" class="form-control" id="email_address"
                               value="<?= $customer->email ?>"/>
                    </div>
                    <div class="form-group">
                        <?= lang("phone", "phone"); ?>
                        <input type="tel" name="phone" class="form-control" id="phone"
                               value="<?= $customer->phone ?>"/>
                    </div>
					<div class="form-group"> <?php
						echo lang("group_area", "group_area");
						$ga_group[""] = "Select Group Area";
						foreach ($group_areas as $group_area) {
							$ga_group[$group_area->areas_g_code] = $group_area->areas_group;
						}
						echo form_dropdown('group_area', $ga_group, $customer->areas_g_code, 'class="form-control tip select" id="group_area" style="width:100%;" placeholder="' . lang("select") . ' ' . lang("group_area") . '" ');
						?>
					</div>
                    <div class="form-group">
                        <?= lang("address1", "address1"); ?>
                        <?php echo form_input('address', $customer->address, 'class="form-control" id="address"'); ?>
                    </div>
                    <div class="form-group">
                        <?= lang("address2", "address2"); ?>
                        <?php echo form_input('address2', $customer->address2, 'class="form-control" id="address2" "'); ?>
                    </div>
                    <div class="form-group">
                        <?= lang("address3", "address3"); ?>
                        <?php echo form_input('address3', $customer->address3, 'class="form-control" id="address3"'); ?>
                    </div>
					<div class="form-group">
						<?= lang('award_points', 'award_points'); ?>
						<?= form_input('award_points', set_value('award_points', $customer->award_points), 'class="form-control tip" id="award_points"'); ?>
					</div>
					<div class="form-group">
						<?= lang('credit_limit', 'credit_limit'); ?>
						<?= form_input('credit_limit', set_value('credit_limit', $customer->credit_limit), 'class="form-control tip" id="credit_limit"'); ?>
					</div>
                </div>
                <div class="col-md-6">
                    <!-- <div class="form-group">
                        <?= lang("postal_code", "postal_code"); ?>
                        <?php echo form_input('postal_code', $customer->postal_code, 'class="form-control" id="postal_code"'); ?>
                    </div> -->
                    
                    
                    <div class="form-group">
                        <?= lang("postal_code", "postal_code"); ?>
                        <?php echo form_input('postal_code', $customer->postal_code, 'class="form-control" id="postal_code"'); ?>

                    </div>
					
					<div class="form-group">
                        <?= lang("Marital Status", "status"); ?>
                        <?php
                        $status[""] = "Select Status";
                        $status['single'] = "Single";
                        $status['married'] = "Married";
                        echo form_dropdown('status', $status, $customer->status, 'class="form-control select" id="status" placeholder="' . lang("select") . ' ' . lang("status") . '" style="width:100%"')
                        ?>
                    </div>
					
                    <div class="form-group">
                        <?= lang("gender", "gender"); ?>
                        <?php
                        $gender[""] = "Select Gender";
                        $gender['male'] = "Male";
                        $gender['female'] = "Female";
                        echo form_dropdown('gender', $gender, $customer->gender, 'class="form-control select" id="gender" placeholder="' . lang("select") . ' ' . lang("gender") . '" style="width:100%"')
                        ?>
                    </div>
					
					<div class="form-group">
                        <?= lang("Identity Number", "cf1"); ?>
                        <?php echo form_input('cf1', $customer->cf1, 'class="form-control" id="cf1"'); ?>
                    </div>
					
                    <div class="form-group">
                        <?= lang("attachment", "cf4"); ?><input id="attachment" type="file" name="userfile" data-show-upload="false" data-show-preview="false"
                       class="file">

                    </div>
                    <div class="form-group">
                        <?= lang("date_of_birth", "cf5"); ?> <?= lang("Ex: YYYY-MM-DD"); ?>
                         <?php echo form_input('date_of_birth', isset($customer->date_of_birth)?date('Y-m-d', strtotime($customer->date_of_birth)):'', 'class="form-control date" id=" date_of_birth"'); ?>
					</div>
                    
					<div class="form-group">
                        <?= lang("start_date", "cf6"); ?> <?= lang("Ex: YYYY-MM-DD"); ?>
                        <?php echo form_input('start_date', isset($customer->start_date)?date('Y-m-d', strtotime($customer->start_date)):'', 'class="form-control date" id=" start_date"'); ?>
                        <!--<a href="javascript:void(0);" class="btn btn-info">Add End Date</a>-->
                    </div>
					<div class="form-group">
                        <?= lang("end_date", "cf7"); ?> <?= lang("Ex: YYYY-MM-DD"); ?>
                        <?php echo form_input('end_date', isset($customer->end_date)?date('Y-m-d', strtotime($customer->end_date)):'', 'class="form-control date" id=" end_date"'); ?>
                    </div>
					<div class="form-group">
                        <?= lang("saleman", "saleman"); ?>
                        <?php
                        foreach($salemans as $saleman){
							$saleman_arr[$saleman->id] = $saleman->username;
						}
                        echo form_dropdown('saleman', $saleman_arr,$customer->saleman, 'class="form-control select" id="saleman" style="width:100%"')
                        ?>
                    </div>
					<div class="form-group"> <?php
						echo lang("payment_term", "payment_term");
						$pt_group[""] = "No Payment Term";
						foreach ($payment_terms as $payment_term) {
							$pt_group[$payment_term->id] = $payment_term->description;
						}
						echo form_dropdown('payment_term', $pt_group, $customer->payment_term_id, 'class="form-control tip select" id="payment_term" style="width:100%;" placeholder="' . lang("select") . ' ' . lang("payment_term") . '" ');
						?>
					</div>
			<!--		<div class="form-group"> <?php
						echo lang("group_area", "group_area");
						$ga_group[""] = "Select Group Area";
						foreach ($group_areas as $group_area) {
							$ga_group[$group_area->areas_g_code] = $group_area->areas_group;
						}
						echo form_dropdown('group_area', $ga_group, $customer->group_sales_area_id, 'class="form-control tip select" id="group_area" style="width:100%;" placeholder="' . lang("select") . ' ' . lang("group_area") . '" ');
						?>
					</div>
					<div class="form-group" id="sale_area_box" <?= ($customer->group_sales_area_id<1?'style="display:none"':'') ?>>
						<?php
						echo lang("sale_area", "sale_area");
						$sa_group[""] = "Select Sale Area";
						foreach ($sale_areas as $sale_area) {
							$sa_group[$sale_area->areacode] = $sale_area->areadescription;
						}
						echo form_dropdown('sale_area', $sa_group, $customer->sales_area_id, 'class="form-control tip select" id="sale_area" style="width:100%;" placeholder="' . lang("select") . ' ' . lang("group_area") . '" ');
						?>
					</div> -->
                </div> 
            </div>
            

        </div>
        <div class="modal-footer">
            <?php echo form_submit('edit_customer', lang('edit_customer'), 'class="btn btn-primary"'); ?>
        </div>
    </div>
    <?php echo form_close(); ?>
</div>
<?= $modal_js ?>
<script type="text/javascript" charset="UTF-8">
    $(document).ready(function () {
        $.fn.datetimepicker.dates['erp'] = <?=$dp_lang?>;
        $(".date").datetimepicker({
            format: site.dateFormats.js_ldate,
            fontAwesome: true,
            language: 'erp',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            forceParse: 0
        });
		
		$("#credit_limit").live('change',function(){
			var credit_limit = $(this).val()-0;
			if(isNaN(credit_limit)){
				$(this).val(0);
				return false;
			}
		});
		$("#group_area").live('change',function(){
			var group_area = $(this).val();
			var option = '';
			if(group_area!=''){
				$.ajax({
					type:"get",
					async:false,
					url: "<?= site_url('customers/get_sale_areas'); ?>",
					dataType: "json",
					data:{
						group_area:group_area
					},
					success:function(re){
						for(var i=0; i<re.length; i++){
							option +='<option value="'+re[i].areacode+'">'+re[i].areadescription+'</option>';
						}
					}
				});
				$('#sale_area').html(option);
				$('#sale_area').change();
				$('#sale_area_box').css("display","block");
			}else{
				$('#sale_area').html(option);
				$('#sale_area').change();
				$('#sale_area_box').css("display","none");
			}
		});
    });
</script>

