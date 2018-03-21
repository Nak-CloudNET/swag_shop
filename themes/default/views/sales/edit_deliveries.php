<?php
	//$this->erp->print_arrays($delivery);
?>

<script type="text/javascript">
    
    $(document).ready(function () {
		
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
			
			var tr = $(this).parent().parent();
			var qty  = parseInt($(this).closest('tr').children('td:eq(2)').text());
			var qty_received = parseInt($(this).val());
			var lastQtyReceived = tr.find(".quantity_received").val();
			var totalQtyReceived = tr.find(".totalQuantityReceived").val();
			var currentQtyReceived = tr.find(".CurrentQuantityReceived").val();
			var lastBalance = qty - (parseInt(totalQtyReceived) + (parseInt(lastQtyReceived) - parseInt(currentQtyReceived)));
			var currentBalanceQty = qty - totalQtyReceived;
			
			if(qty>=qty_received && qty_received>0){
				tr.find(".balance").text(lastBalance);
			}else if(qty < qty_received && qty >= 0){
				$(this).val(0);
				tr.find(".balance").text(currentBalanceQty);
			}else if(qty_received<0){
				$(this).val(0);
				tr.find(".balance").text(currentBalanceQty);
			}else if(!(qty_received)){
				$(this).val(0);
				tr.find(".balance").text(currentBalanceQty);
			}
			
		});
		
		
		$(".remove-row").click(function(){
			$(this).closest('tr').remove();
		});

    });
		

</script>

<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-plus"></i><?= lang('edit_delivery'); ?></h2>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?php echo lang('enter_info'); ?></p>
                <?php
                $attrib = array('data-toggle' => 'validator', 'role' => 'form', 'class' => 'edit-so-form');
                echo form_open_multipart("sales/save_edit_deliveries/".$delivery->id, $attrib)
                ?>
                <div class="row">
                    <div class="col-lg-12">
                        <?php if ($Owner || $Admin) { ?>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <?= lang("date", "sldate"); ?>
                                    <?php echo form_input('date',$this->erp->hrld($delivery->date), 'class="form-control input-tip datetime" id="sldate"'); ?>
								</div>
                            </div>
                        <?php } ?>
						
                        <div class="col-md-4">
							<?= lang("delivery_reference", "dlref"); ?>
								<div class="form-group">
									<?php echo form_input('delivery_reference',$delivery->do_reference_no,'class="form-control input-tip" id="dref" required="required" style="pointer-events:none"'); ?>
								</div>
                        </div>
						
                        <div class="col-md-4">
							<?= lang("sale_reference", "sref"); ?>
								<div class="form-group">
									<?php echo form_input('sale_reference',$delivery->sale_reference_no,'class="form-control input-tip" id="sref" style="pointer-events:none"'); ?>
								</div>
								
                        </div>
						
						<div class="col-md-4">
							<?= lang("customer", "customer"); ?>
								<div class="form-group">
									<?php echo form_input('cust',$delivery->customer,'class="form-control input-tip" id="cust" style="pointer-events:none"'); ?>
									
								</div>
								
                        </div>
						
						<div class="col-md-4">
							<?= lang("saleman_by", "saleman_by"); ?>
								<div class="form-group">
									<?php echo form_input('saleman_by',$saleInfo->username,'class="form-control input-tip saleman_by" id="saleman_by" style="pointer-events:none"'); ?>
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
												<th class="col-md-4"><?= lang("product_name") . " (" . lang("product_code") . ")"; ?></th>
												<?php
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
												//$this->erp->print_arrays($ordered_items);
												foreach($quantity_recs as $quantity_rec){
													$number++;
													$totalQtyReceived = $quantity_rec['qty'] - $quantity_rec['balance']; 
													
													echo '<tr style="height:45px;">
															<td style="text-align:center;">'.$number.'</td>
															<td>'.$quantity_rec['pname'].'</td>
															<input type="hidden" class="product_name" name="product_name[]" value = "'.$quantity_rec['pname'].'" id="product_name" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" class="product_option" name="product_option[]" value = "'.$quantity_rec['option_id'].'" id="option_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" class="product_id" name="product_id[]" value = "'.$quantity_rec['pid'].'" id="product_id" style="width: 150px; height: 30px;text-align:center;">
															<input type="hidden" class="ditem_id" name="ditem_id[]" value = "'.$quantity_rec['ditem'].'" id="ditem_id" style="width: 150px; height: 30px;text-align:center;">
															<td id="quantity" style="text-align:center;">'.$quantity_rec['qty'].'</td>
															<td>
																<input type="text" class="quantity_received" name="quantity_received[]" value = "'.$this->erp->formatNumber($quantity_rec['qty_received']).'" id="quantity_received" style="width: 150px; height: 30px;text-align:center;">
																<input type="hidden" class="totalQuantityReceived" name="totalQuantityReceived[]" value = "'.$this->erp->formatNumber($totalQtyReceived).'" id="totalQuantityReceived" style="width: 150px; height: 30px;text-align:center;">
																<input type="hidden" class="CurrentQuantityReceived" name="CurrentQuantityReceived[]" value = "'.$this->erp->formatNumber($quantity_rec['qty_received']).'" id="CurrentQuantityReceived" style="width: 150px; height: 30px;text-align:center;">
																
																
															</td>
															<td>
																<p class="balance" name="balance[]" id="balance" style="width: 150px; height: 30px; text-align:center;">'.$quantity_rec['balance'].'</p>
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
											<?php echo form_textarea('note',$delivery->note, 'class="form-control" id="slnote" style="margin-top: 10px; height: 100px;"'); ?>
											
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

<div class="modal" id="prModal" tabindex="-1" role="dialog" aria-labelledby="prModalLabel" aria-hidden="true">
	<div class="modal-footer">
		<button type="button" class="btn btn-primary" id="editItem"><?= lang('submit') ?></button>
	</div>
</div>

	