<?php
	//$this->erp->print_arrays($delivery_items);
?>

<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-plus"></i><?= lang('add_delivery'); ?></h2>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?php echo lang('enter_info'); ?></p>
                <?php
                $attrib = array('data-toggle' => 'validator', 'role' => 'form', 'class' => 'edit-so-form');
                echo form_open_multipart("sales/add_new_delivery/", $attrib)
                ?>
				
				<input type ="hidden" value="<?= $deliveries->id ?>" name="sale_id">
				<input type ="hidden" value="<?= $deliveries->customer ?>" name="customer">
				<input type ="hidden" value="<?= $deliveries->delivery_by ?>" name="delivery_by">
				<input type ="hidden" value="<?= $deliveries->saleman_by ?>" name = "saleman_by">
				<input type ="hidden" value="<?= $status?>" name = "status">
				
                <div class="row">
                    <div class="col-lg-12">
                        <?php if ($Owner || $Admin) { ?>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <?= lang("date", "sldate"); ?>
                                    <?php echo form_input('date',$date, 'class="form-control input-tip datetime" id="sldate"'); ?>
								</div>
                            </div>
                        <?php } ?>
						
                        <div class="col-md-4">
							<?= lang("delivery_reference", "slref"); ?>
								<div style="float:left;width:88%;">
									<div class="form-group">
										<?php echo form_input('delivery_reference',$reference,'class="form-control input-tip" id="slref" required="required"'); ?>
										<input type="hidden"  name="temp_reference_no"  id="temp_reference_no" value="<?= $reference ?>" />
									</div>
								</div>
								
								<div style="float: left; width: 12%; height: 34px; border: 1px solid gray; padding-top: 3px; padding-left: 6px;">
									<input type="checkbox" name="ref_status" id="ref_st" value="1" style="margin-top:3px;">
								</div>
                        </div>
						
                        <div class="col-md-4">
							<?php
								if($status=="invoice"){
									$ref_no = "invoice_reference_no";
								}else{
									$ref_no = "sale_order_reference_no";
								}
							?>
							<?= lang($ref_no, "dref"); ?>
							<div class="form-group">
								<?php echo form_input('sale_reference',$deliveries->reference_no,'class="form-control input-tip" id="sref" style="pointer-events:none;"'); ?>
							</div>
								
                        </div>
						
						<div class="col-md-4">
							<?= lang("customer", "cust"); ?>
								<div class="form-group">
									<?php echo form_input('customer',$deliveries->customer,'class="form-control input-tip" id="dcustomer" style="pointer-events:none;"'); ?>		
								</div>
                        </div>
						
						<div class="col-md-4">
							<?= lang("saleman_by", "saleman_by"); ?>
								<div class="form-group">
									<?php echo form_input('saleman_by',$user->username,'class="form-control input-tip" id="saleman_by" style="pointer-events:none;"'); ?>
								</div>
                        </div>
						
						<div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("delivery_by", "delivery_by"); ?>
                                <?php
									$driver[''] = '';
									foreach($drivers as $dr) {
										$driver[$dr->id] = $dr->name;
									}
									echo form_dropdown('delivery_by', $driver, '', 'class="form-control input-tip" id="delivery_by"');
								?>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                        
                        <div class="col-md-12">
                            <div class="control-group table-group">
                                <label class="table-label"><?= lang("order_items"); ?> *</label>
                                <div class="controls table-controls">
                                    <table id="slTable"
                                           class="table items table-striped table-bordered table-condensed table-hover">
                                        <thead>
											<tr>
												<th class="col-md-1" style="text-align:center;"><?= lang("no"); ?></th>
												<?php if($setting->show_code == 0) { ?>
													<th class="col-md-4"><?= lang("product_name"); ?></th>
												<?php }else if($setting->separate_code == 0){ ?>
													<th class="col-md-4"><?= lang("product_name") . " (" . lang("product_code") . ")"; ?></th>
												<?php }else { ?>
													<th class="col-md-4"><?= lang("product_code"); ?></th>
													<th class="col-md-4"><?= lang("product_name"); ?></th>
												<?php }
												if ($Settings->product_serial) {
													echo '<th class="col-md-2">' . lang("serial_no") . '</th>';
												}
												?>
												<th class="col-md-2"><?= lang("quantity"); ?></th>
												<th class="col-md-2"><?= lang("quantity received"); ?></th>
												<th class="col-md-2"><?= lang("balance"); ?></th>
												<th class="col-md-1" style="width: 30px !important; text-align: center;"><i class="fa fa-trash-o col-md-1"
														style="opacity:0.5; filter:alpha(opacity=50);"></i>
												</th>
											</tr>
                                        </thead>
                                        <tbody>
											<?php
												$number=0;
												foreach($delivery_items as $delivery){
													$qty = $delivery['quantity'];
													$bqty = $delivery['quantity'] - $delivery['quantity_received'];
													
													$number++;
													echo '<tr style="height:45px;">
															<td style="text-align:center;">'.$number.'</td>';
															if($setting->show_code == 0){
																echo'<td>'.$delivery['product_name'].'<span id="edit_option" class="pull-right fa fa-edit tip pointer edit"></span></td>';
															}else if($setting->separate_code == 0){
																echo'<td>'.$delivery['product_code'].'  '.$delivery['product_name'].'<span id="edit_option" class="pull-right fa fa-edit tip pointer edit"></span></td>';
															}else{
																echo'<td>'.$delivery['product_code'].'</td>';
																echo'<td>'.$delivery['product_name'].'<span class="pull-right fa fa-edit tip pointer edit"></span></td>';
															}
													echo   '<input type="hidden" value="'.$delivery['id'].'" name="delivery_id[]" id="delivery_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['product_id'].'" name="product_id[]" id="product_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['product_name'].'" name="product_name[]" id="product_name" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['product_code'].'" name="product_code[]" id="product_code" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['item_discount'].'" name="item_discount[]" id="item_discount" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['option_id'].'" name="option_id[]" id="option_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['product_type'].'" name="product_type[]" id="product_type" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['unit_price'].'" name="unit_price[]" id="unit_price" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['warehouse_id'].'" name="warehouse_id[]" id="warehouse_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['product_noted'].'" name="product_noted[]" id="product_noted" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['net_unit_price'].'" name="net_unit_price[]" id="net_unit_price" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" value="'.$delivery['item_tax'].'" name="item_tax[]" id="item_tax" style="width: 150px; height: 30px;text-align:center;">
															
															<td id="quantity" style="text-align:center;">'.$qty.'</td>
															
															<input type="hidden" value="'.$qty.'" name="quantity[]" id="quantity-x">
															<input type="hidden" value="'.$bqty.'" name="bquantity[]" id="bquantity">
															<input type="hidden" value="'.$delivery['quantity_received'].'" name="rquantity[]" id="rquantity">
															
															<td>
																<input type="text" class="quantity_received" value ="'.$bqty.'"name="quantity_received[]" id="quantity_received" style="width: 150px; height: 30px;text-align:center;">
																<input type="hidden" class="cur_quantity_received" value ="'.$bqty.'"name="cur_quantity_received[]" id="cur_quantity_received" style="width: 150px; height: 30px;text-align:center;">
															</td>
															
															<td>
																<p class="balance" name="balance[]" id="balance" style="width: 150px; height: 30px; text-align:center;">0</p>
															</td>
															<td style="text-align:center;">
																<i class="fa fa-times remove-row" aria-hidden="true" style="color:red; cursor: pointer;"></i>
															</td>
														  </tr>';
												}
											?>
											
										</tbody>
                                        <tfoot>
											
										</tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
						
						<div class="col-sm-12">

							<div class="col-md-4">
								<div class="form-group">
									<?= lang("document", "document") ?>
									<input id="document" type="file" name="document" data-show-upload="false" data-show-preview="false" class="form-control file">
								</div>
							</div>
							
							<div class="col-md-4">
								<div class="form-group">
									<?= lang("document", "document") ?>
									<input id="document1" type="file" name="document1" data-show-upload="false" data-show-preview="false" class="form-control file">
								</div>
							</div>
							
							<div class="col-md-4">
								<div class="form-group">
									<?= lang("document", "document") ?>
									<input id="document2" type="file" name="document2" data-show-upload="false" data-show-preview="false" class="form-control file">
								</div>
							</div>

						  
							<div class="clearfix"></div>
							
							
							<div class="row" id="bt">
								<div class="col-md-12">
									<div class="col-md-6">
										<div class="form-group">
											<?= lang("deliver_note", "delivery_note"); ?>
											<?php echo form_textarea('note', (isset($_POST['note']) ? $_POST['note'] : ""), 'class="form-control" id="slnote" style="margin-top: 10px; height: 100px;"'); ?>
											
										</div>
									</div>
								</div>
							</div>
							
							<div class="col-md-12">
								<div
									class="fprom-group"><?php echo form_submit('edit_sale', lang("submit"), 'id="edit_sale" class="btn btn-primary" style="padding: 6px 15px; margin:15px 0;"'); ?>
									<button type="button" class="btn btn-danger" id="reset"><?= lang('reset') ?></button>
								</div>
							</div>
						</div>
                </div>
                
                <?php echo form_close(); ?>

            </div>

        </div>
    </div>
</div>


<div class="modal" id="option" tabindex="-1" role="dialog" aria-labelledby="prModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true"><i
                            class="fa fa-2x">&times;</i></span><span class="sr-only"><?=lang('close');?></span></button>
                <h4 class="modal-title" id="prModalLabel"></h4>
            </div>
            <div class="modal-body" id="pr_popover_content">
                <form class="form-horizontal" role="form">
                    <?php if ($Settings->tax1) { ?><!--
                        <div class="form-group">
                            <label class="col-sm-4 control-label"><?= lang('product_tax') ?></label>
                            <div class="col-sm-8">
                                <?php
                                $tr[""] = "";
                                foreach ($tax_rates as $tax) {
                                    $tr[$tax->id] = $tax->name;
                                }
                                echo form_dropdown('ptax', $tr, $deliveries->order_tax_id, 'id="ptax" class="form-control pos-input-tip" style="width:100%;"');
                                ?>
                            </div>
                        </div>-->
                    <?php } ?>
                    <?php if ($Settings->product_serial) { ?>
                        <div class="form-group">
                            <label for="pserial" class="col-sm-4 control-label"><?= lang('serial_no') ?></label>

                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pserial" value="">
                            </div>
                        </div>
                    <?php } ?>
                    <div class="form-group">
                        <label for="pquantity" class="col-sm-4 control-label"><?= lang('quantity') ?></label>

                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="pquantity"value="">
							<input type="hidden" class="form-control" id="cquantity" value="">
							<input type="hidden" class="form-control" id="item_quantity" value="">
							
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="poption" class="col-sm-4 control-label"><?= lang('product_option') ?></label>
                        <div class="col-sm-8">
                            <div id="poptions-div">
								<select id="pro-option" class="col-sm-12"></select>
								<input type="hidden" name ="fixed_option" id="fixed_option">
							</div>
							<input type="hidden" name ="product_id" id ="product_id" value="">
                        </div>
                    </div>
                    <?php if ($Settings->product_discount || ($Owner || $Admin || $this->session->userdata('allow_discount'))) { ?>
                        <!--<div class="form-group">
                            <label for="pdiscount"
                                   class="col-sm-4 control-label"><?= lang('product_discount') ?></label>

                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pdiscount">
                            </div>
                        </div>
                    <?php } ?>
					<?php if ($Owner || $Admin || $GP['sales-price']) { ?>
                    <div class="form-group">
                        <label for="pprice" class="col-sm-4 control-label"><?= lang('unit_price') ?></label>

                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="pprice">
							<input type="hidden" class="form-control" id="remember_pprice">
                        </div>
                    </div>
					<?php } ?>
					<div class="form-group">
                        <label for="pnote" class="col-sm-4 control-label"><?= lang('product_note') ?></label>

                        <div class="col-sm-8">
                            <input type="text" class="form-control kb-pad" id="pnote">
                        </div>
                    </div>
                    <table class="table table-bordered table-striped">
                        <tr>
                            <th style="width:25%;"><?= lang('net_unit_price'); ?></th>
                            <th style="width:25%;"><span id="net_price"></span></th>
                            <th style="width:25%;"><?= lang('product_tax'); ?></th>
                            <th style="width:25%;"><span id="pro_tax"></span></th>
                        </tr>
                    </table>
                    <input type="hidden" id="punit_price" value=""/>
                    <input type="hidden" id="old_tax" value=""/>
                    <input type="hidden" id="old_qty" value=""/>
                    <input type="hidden" id="old_price" value=""/>
                    <input type="hidden" id="row_id" value=""/>-->
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="editItem"><?= lang('submit') ?></button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
		<?php if($deliveries) {?>
			localStorage.setItem('delivery_by', '<?= $deliveries->delivery_by ?>');
			localStorage.setItem('delivery_items', JSON.stringify(<?= $delivery_items; ?>));
        <?php } ?>
		if (delivery_by = localStorage.getItem('delivery_by')) {
            $('#delivery_by').val(delivery_by);
        }
		$("#slref").attr('disabled','disabled');
		$('#ref_st').on('ifChanged', function() {
		  if ($(this).is(':checked')) {
			$("#slref").prop('disabled', false);
			$("#slref").val("");
		  }else{
			$("#slref").prop('disabled', true);
			var temp = $("#temp_reference_no").val();
			$("#slref").val(temp);
			
		  }
		});
		
		$( "#slref" ).blur(function(){
			var ref_no = $("#slref").val();
			if(ref_no){
				$.ajax({
                    type: "get",
                    url: site.base_url + "sales/verifyReference/"+ref_no,
                    dataType: "json",
                    success: function (data) {
						if(data){
							alert("Duplicated reference number");
						}
                    }
                });
			}
		});
		
		$( "#other" ).click(function() {
			$( ".target" ).change();
		});
		
		$(".balance").prop('disabled', true);
		
		$( ".quantity_received" ).keyup(function(e) {
			if ((e.which >= 48 && e.which <= 57) || (e.which >=96 && e.which <=105 || e.which ==13 || e.which == 8 || e.which == 46) ){
				var str = $.trim($(this).val());
				if(parseInt(str) || str==0){
					var tr = $(this).parent().parent();
					var qty  = parseInt($(this).closest('tr').children('td:eq(2)').text());
					var bqty  = parseInt($(this).closest('tr').children('#bquantity').val());
					var rqty  = parseInt($(this).closest('tr').children('#rquantity').val());
					var curQty = Number(str);
					if(curQty >= 0 && curQty <= bqty){
						var balance = bqty - curQty; 
						tr.find(".balance").text(balance);
						tr.find('.cur_quantity_received').val(curQty);
					}else if(curQty >= 0 && curQty > bqty){
						tr.find("#quantity_received").val(bqty);
					}
					
				}
			}else{
				var tr = $(this).parent().parent();
				var bqty  = parseInt($(this).closest('tr').children('#bquantity').val());
				tr.find("#quantity_received").val(bqty);
				alert("allow only number");
			}
			
			// calculate balance
			var quantity_balance = $('#bquantity').val();
			var current_quantity = $(this).val();
			var last_balance =  quantity_balance - current_quantity;
			$('#balance').val();
			
		});
		
		$('.edit').click(function(){
			var row = $(this).parent().parent();
			var product_id = row.find('#product_id').val();
			localStorage.setItem('product_id', product_id);
			var product_option = row.find('#option_id').val();
			var item_discount = row.find('#item_discount').val();
			var unit_price = row.find('#unit_price').val();
			var product_noted = row.find('#product_noted').val();
			var net_unit_price = row.find('#net_unit_price').val();
			var item_tax = row.find('#item_tax').val();
			var option_id = row.find('#option_id').val();
			$('#pdiscount').val(item_discount);
			$('#pprice').val(unit_price);
			$('#remember_pprice').val(unit_price);
			$('#pnote').val(product_noted);
			$('#net_price').text(net_unit_price);
			$('#pro_tax').text(item_tax);
			$('#fixed_option').val(option_id);
			
			$.ajax({
				type: 'get',
				url: site.base_url+'sales/getProductVariant',
				dataType: "json",
				data: { pro_id: product_id },
				success: function (data){
					if(data){
						$("#pro-option").empty();
						$.each(data, function (i,item) {
							$("#pro-option").append('<option att='+item.qty_unit+' value='+item['id']+'>'+item['name']+'='+item.qty_unit+'</option>');
							if(item['id'] == option_id) {
								$('#pro-option').select2("val",option_id);
								var rqty = row.find('#cur_quantity_received').val();
								var quantity = rqty/item.qty_unit;
								if(quantity % 1 != 0){
									var qty = (quantity - (quantity % 1));
									$('#pquantity').val(qty);
									$('#cquantity').val(quantity);
									$('#item_quantity').val(quantity);
								}else{
									$('#pquantity').val(quantity);
									$('#cquantity').val(quantity);
									$('#item_quantity').val(quantity);
								}
								
							}
						});
					}else{
						$("#pro-option").select2("val", "");
						$("#pro-option").empty();
					}
				}
			});
			//$('#pro-option').select2('val', option_id);
			
			$('#option').appendTo("body").modal('show');
		});
		
		$('#editItem').click(function (){
			var quantity = $('#pquantity').val();
			var element = $('#pro-option').find('option:selected'); 
			var unit = element.attr("att"); 
			var total_quantity = quantity * unit;
			var balance_quantity = $('#bquantity').val();
			var last_balance = balance_quantity - total_quantity;
			$('#quantity_received').val(total_quantity);
			$('#cur_quantity_received').val(total_quantity);
			$('#balance').text(last_balance);
			$('#option').modal('hide');
		});
		
		
		$("#pro-option").change(function(){
			var product_id = localStorage.getItem('product_id');
			var option_id = $(this).val();
			var fixed_option = $('#fixed_option').val();
			$.ajax({
				type: 'get',
				url: site.base_url+'sales/getProductVariantOptionAndID',
				dataType: "json",
				data: { product_id: product_id,option_id: option_id},
				success: function (data) {
					$.ajax({
						type: 'get',
						url: site.base_url+'sales/getProductVariantOptionAndID',
						dataType: "json",
						data: { product_id: product_id,option_id: fixed_option},
						success: function (records) {
							
							var unit_quantity = records.qty_unit/data.qty_unit;
							var quantity = $('#cquantity').val();
							var new_quantity = quantity * unit_quantity;
							if(new_quantity >= 1 ){
								if(new_quantity % 1 != 0){
									var new_quantity_ = (new_quantity - (new_quantity % 1));
									$('#pquantity').val(new_quantity_);
									$('#item_quantity').val(new_quantity_);
									alert("Some items still remain in stock");
								}else{
									$('#pquantity').val(new_quantity);
									$('#item_quantity').val(new_quantity);
								}
								
							}else{
								var default_option = $('#fixed_option').val();
								var default_quantity = $('#cquantity').val();
								if(default_quantity % 1 != 0){
									var d_quantity_ = (default_quantity - (default_quantity % 1));
									alert("Cannot delivery by this option or delivery quantity = 0");
									$('#pro-option').select2("val",default_option);
									$('#pquantity').val(d_quantity_);
								}else{
									alert("Cannot delivery by this option or delivery quantity = 0");
									$('#pro-option').select2("val",default_option);
									$('#pquantity').val(default_quantity);
								}
								
							}
						}
					});
				}
			});
			
		});
		
		
		
		
		$("#pquantity").keyup(function(){
			var item_quantity = Number($('#item_quantity').val());
			if($(this).val()>item_quantity){
				$(this).val(item_quantity);
			}
		});
			
		
		
		$(".remove-row").click(function(){
			$(this).closest('tr').remove();
		});

		$('#myModal').on('shown.bs.modal', function () {
		  $('#myInput').focus();
		});
		
		if (product_variant = localStorage.getItem('product_variant')) {
			//var variants = JSON.parse(product_variant);
			console.log(product_variant);
        }
		
		if (product_option = localStorage.getItem('product_option')) {
			$('#option_id').val(product_option);
		}
		
		
    });
		

</script>


	