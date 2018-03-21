<script type="text/javascript">
    $(document).ready(function () {
        $('#form').hide();
        $('.toggle_down').click(function () {
            $("#form").slideDown();
            return false;
        });
        $('.toggle_up').click(function () {
            $("#form").slideUp();
            return false;
        });
        $("#product").autocomplete({
            source: '<?= site_url('reports/suggestions'); ?>',
            select: function (event, ui) {
                $('#product_id').val(ui.item.id);
                //$(this).val(ui.item.label);
            },
            minLength: 1,
            autoFocus: false,
            delay: 300,
        });
    });
</script>
<style type="text/css">
	.numeric {
		text-align:right !important;
	}
</style>
<div class="box">
    <div class="box-header">
        <h2 class="blue"><i
                class="fa-fw fa fa-star"></i><?=lang('ar_by_customer') . ' (' . lang('All_Customer') . ')';?>
        </h2>
		<div class="box-icon">
            <ul class="btn-tasks">
                <li class="dropdown">
                    <a href="#" class="toggle_up tip" title="<?= lang('hide_form') ?>">
                        <i class="icon fa fa-toggle-up"></i>
                    </a>
                </li>
                <li class="dropdown">
                    <a href="#" class="toggle_down tip" title="<?= lang('show_form') ?>">
                        <i class="icon fa fa-toggle-down"></i>
                    </a>
                </li>
            </ul>
        </div>
        <div class="box-icon">
            <ul class="btn-tasks">
                <li class="dropdown">
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#"><i class="icon fa fa-tasks tip" data-placement="left" title="<?=lang("actions")?>"></i></a>
                    <ul class="dropdown-menu pull-right" class="tasks-menus" role="menu" aria-labelledby="dLabel">
						 <li>
                            <a href="javascript:void(0)" id="combine_payable" data-action="combine_payable">
                                <i class="fa fa-money"></i> <?=lang('combine_payable')?>
                            </a>
                        </li>
                        <!--<li>
                            <a href="<?=site_url('sales/add')?>">
                                <i class="fa fa-plus-circle"></i> <?=lang('add_sale')?>
                            </a>
                        </li>-->
						<?php if ($Owner || $Admin) { ?>
							<li>
								<a href="#" id="excel" data-action="export_excel">
									<i class="fa fa-file-excel-o"></i> <?=lang('export_to_excel')?>
								</a>
							</li>
							<li>
								<a href="#" id="pdf" data-action="export_pdf">
									<i class="fa fa-file-pdf-o"></i> <?=lang('export_to_pdf')?>
								</a>
							</li>
						<?php }else{ ?>
							<?php if($GP['accounts-export']) { ?>
								<li>
									<a href="#" id="excel" data-action="export_excel">
										<i class="fa fa-file-excel-o"></i> <?=lang('export_to_excel')?>
									</a>
								</li>
								<li>
									<a href="#" id="pdf" data-action="export_pdf">
										<i class="fa fa-file-pdf-o"></i> <?=lang('export_to_pdf')?>
									</a>
								</li>
							<?php }?>
						<?php }?>	
                        <li>
                            <a href="#" id="combine" data-action="combine">
                                <i class="fa fa-file-pdf-o"></i> <?=lang('combine_to_pdf')?>
                            </a>
                        </li>
                        <li class="divider"></li>
                    </ul>
                </li>
                <?php if (!empty($warehouses)) {
                    ?>
                    <li class="dropdown">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#"><i class="icon fa fa-building-o tip" data-placement="left" title="<?=lang("warehouses")?>"></i></a>
                        <ul class="dropdown-menu pull-right" class="tasks-menus" role="menu" aria-labelledby="dLabel">
                            <li><a href="<?=site_url('purchases')?>"><i class="fa fa-building-o"></i> <?=lang('all_warehouses')?></a></li>
                            <li class="divider"></li>
                            <?php
                            	foreach ($warehouses as $warehouse) {
                            	        echo '<li ' . ($warehouse_id && $warehouse_id == $warehouse->id ? 'class="active"' : '') . '><a href="' . site_url('purchases/' . $warehouse->id) . '"><i class="fa fa-building"></i>' . $warehouse->name . '</a></li>';
                            	    }
                                ?>
                        </ul>
                    </li>
                <?php }
                ?>
            </ul>
        </div>
    </div>
<?php if ($Owner) {?>
    <div style="display: none;">
        <input type="hidden" name="form_action" value="" id="form_action"/>
        <?=form_submit('performAction', 'performAction', 'id="action-form-submit"')?>
    </div>
    <?= form_close()?>
<?php }
?>  
	<div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?=lang('list_results');?></p>
				<div id="form">

                    <?php echo form_open("account/ar_by_customer"); ?>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("start_date", "start_date"); ?>
                                <?php echo form_input('start_date', (isset($_POST['start_date']) ? $_POST['start_date'] : $start_date), 'class="form-control datetime" id="start_date"'); ?>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("end_date", "end_date"); ?>
                                <?php echo form_input('end_date', (isset($_POST['end_date']) ? $_POST['end_date'] : $end_date), 'class="form-control datetime" id="end_date"'); ?>
                            </div>
                        </div>
						<div class="col-sm-4">
							<div class="form-group">
								<?= lang("customer", "customer"); ?>
								<?php echo form_input('customer', (isset($_POST['customer'])? $_POST['customer'] : ""), 'class="form-control" id="customer"'); ?>
							</div>
						</div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label" for="balance"><?= lang("balance"); ?></label>
                                <?php
                                    $wh["all"] = "All";
                                    $wh["balance0"] = "Zero Balance";
                                    $wh["owe"] = "Owe";
                                
                                echo form_dropdown('balance', $wh, (isset($_POST['balance']) ? $_POST['balance'] : "all"), 'class="form-control" id="balance" data-placeholder="' . $this->lang->line("select") . " " . $this->lang->line("balance") . '"');
                                ?>
                            </div>
                        </div>
						
                    </div>
                    <div class="form-group">
                        <div
                            class="controls"> <?php echo form_submit('submit_report', $this->lang->line("submit"), 'class="btn btn-primary"'); ?> </div>
                    </div>
                    <?php echo form_close(); ?>

                </div>

                <div class="clearfix"></div>
                <div class="table-responsive">
                    <table id="POData" cellpadding="0" cellspacing="0" border="0"
                           class="table table-bordered table-hover table-striped">
                        <thead>
						<?php 
							foreach($cust_data as $cus){
								$gbalance=0;
						?>
                        <tr>
                            <th class="th_parent" colspan="10">Customer: <?= $cus['customerName'] ?></th>
                        </tr>
						<tr class="active">
                            <th class="th_data"><?php echo $this->lang->line("reference_no"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("date"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("type"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("amount"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("return"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("paid"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("deposit"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("discount"); ?></th>
                            <th class="th_data"><?php echo $this->lang->line("balance"); ?></th>
                            <th class="th_data" style="width:100px;"><?php echo $this->lang->line("actions"); ?></th>
                        </tr>
						<?php 
								
								$subTotal = $subReturn = $subDeposit = $subPaid = $subDiscount = 0;
								foreach($cus['customerDatas']['custSO'] as $custData){
									$subTotal += $custData->grand_total;
									$subReturn += $custData->amount_return;
									$subDeposit += $custData->amount_deposit;
									$subDiscount += $custData->order_discount;
									$sub_balance = ($custData->grand_total - $custData->amount_return - $custData->amount_deposit - $custData->order_discount);
									$gbalance+=$sub_balance;
						?>
									<tr>
										<td nowrap="nowrap"><?= $custData->reference_no ?></td>
										<td><?= $this->erp->hrsd($custData->date) ?></td>
										<td><?= (explode('-', $custData->reference_no)[0]=='INV'?"Invoice":(explode('/', $custData->reference_no)[0]=='SALE'?"Sale":"Not Assigned")) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($custData->grand_total) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($custData->amount_return) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney(0) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($custData->amount_deposit) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($custData->order_discount) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($sub_balance) ?></td>
										<td><a style="color:#000 !important;">View</a></td>
									</tr>
						<?php 	
									foreach($custData->payments as $cusPmt){
										$subPaid += abs($cusPmt->amount);
						?>
										<tr>
											<td nowrap="nowrap" style="text-align:right;"><?= $cusPmt->reference_no ?></td>
											<td><?= $this->erp->hrsd($cusPmt->date) ?></td>
											<td><?= (explode('/', $cusPmt->reference_no)[0]=='RV'?"Payment":(explode('-', $cusPmt->reference_no)[0]=='RV'?"Payment":"Not Assigned")) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(0) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(0) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(abs($cusPmt->amount)) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(0) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(0) ?></td>
											<td class="numeric"><?= $this->erp->formatMoney(abs($cusPmt->amount)-$sub_balance) ?></td>
											<td><a style="color:#000 !important;">View</a></td>
										</tr>
						<?php
										$gbalance -= abs($cusPmt->amount);
										$sub_balance -= abs($cusPmt->amount);
									}//end supp payment
								}//end supp data
								
								//********** total *********//
						?>
									<tr>
										<td colspan="3" align="right">Total:</td>
										<td class="numeric"><?= $this->erp->formatMoney($subTotal) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($subReturn) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($subPaid) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($subDeposit) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($subDiscount) ?></td>
										<td class="numeric"><?= $this->erp->formatMoney($gbalance) ?></td>
									</tr>
						<?php
							}//end supp list
						?>
                        
                        </thead>
                        <tbody>
						
                        </tbody>
                        <tfoot class="dtFilter">
                        <tr class="active">
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>