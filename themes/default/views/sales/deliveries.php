<script>
	$(document).ready(function () {
        CURI = '<?= site_url('sales/deliveries'); ?>';
    });
</script>

<?php
	$start_date=date('Y-m-d',strtotime($start));
	$rep_space_end=str_replace(' ','_',$end);
	$end_date=str_replace(':','-',$rep_space_end);
?>

<script>
    $(document).ready(function () {
        var oTable = $('#sale_item').dataTable({
            "aaSorting": [[0, "desc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('sales/getDeliveries').'/'.$start_date.'/'.$end_date ?>',
            'fnServerData': function (sSource, aoData, fnCallback) {
                aoData.push({
                    "name": "<?= $this->security->get_csrf_token_name() ?>",
                    "value": "<?= $this->security->get_csrf_hash() ?>"
                });
                $.ajax({'dataType': 'json', 'type': 'POST', 'url': sSource, 'data': aoData, 'success': fnCallback});
            },
            'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                var oSettings = oTable.fnSettings();
                nRow.id = aData[0];
                nRow.className = "delivery_link";
                return nRow;
            },
            "aoColumns": [{
                "bSortable": false,
                "mRender": checkbox
            }, {"mRender": fld}, null, null, null, null, {"mRender": currencyFormat},{"mRender": row_status}, {"bSortable": false}],
			"fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                var gtotal = 0;
                for (var i = 0; i < aaData.length; i++) {
					gtotal += parseFloat(aaData[aiDisplay[i]][6]);
                }
                var nCells = nRow.getElementsByTagName('th');
                nCells[6].innerHTML = currencyFormat(parseFloat(gtotal));
            }
        }).fnSetFilteringDelay().dtFilter([
            {column_number: 1, filter_default_label: "[<?=lang('date');?> (yyyy-mm-dd)]", filter_type: "text", data: []},
            {column_number: 2, filter_default_label: "[<?=lang('do_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 3, filter_default_label: "[<?=lang('sale_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 4, filter_default_label: "[<?=lang('customer');?>]", filter_type: "text", data: []},
            {column_number: 5, filter_default_label: "[<?=lang('address');?>]", filter_type: "text", data: []},
			{column_number: 7, filter_default_label: "[<?=lang('status');?>]", filter_type: "text", data: []},
        ], "footer");
    });
	
	
	
	$(document).ready(function () {
        var oTable = $('#sale_order').dataTable({
            "aaSorting": [[0, "desc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('sales/getSaleOrderDeliveries').'/'.$start_date.'/'.$end_date ?>',
            'fnServerData': function (sSource, aoData, fnCallback) {
                aoData.push({
                    "name": "<?= $this->security->get_csrf_token_name() ?>",
                    "value": "<?= $this->security->get_csrf_hash() ?>"
                });
                $.ajax({'dataType': 'json', 'type': 'POST', 'url': sSource, 'data': aoData, 'success': fnCallback});
            },
            'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                var oSettings = oTable.fnSettings();
                nRow.id = aData[0];
                nRow.className = "sale_order_delivery_link";
                return nRow;
            },
            "aoColumns": [{
                "bSortable": false,
                "mRender": checkbox
            }, {"mRender": fld}, null, null, null, null, {"mRender": currencyFormat},{"mRender": row_status}, {"bSortable": false}],
			"fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                var gtotal = 0;
                for (var i = 0; i < aaData.length; i++) {
					gtotal += parseFloat(aaData[aiDisplay[i]][6]);
                }
                var nCells = nRow.getElementsByTagName('th');
                nCells[6].innerHTML = currencyFormat(parseFloat(gtotal));
            }
        }).fnSetFilteringDelay().dtFilter([
            {column_number: 1, filter_default_label: "[<?=lang('date');?> (yyyy-mm-dd)]", filter_type: "text", data: []},
            {column_number: 2, filter_default_label: "[<?=lang('do_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 3, filter_default_label: "[<?=lang('sale_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 4, filter_default_label: "[<?=lang('customer');?>]", filter_type: "text", data: []},
            {column_number: 5, filter_default_label: "[<?=lang('address');?>]", filter_type: "text", data: []},
			{column_number: 7, filter_default_label: "[<?=lang('status');?>]", filter_type: "text", data: []},
        ], "footer");
    });
	
	
	
</script>

<?php if ($Owner) { ?><?= form_open('sales/delivery_actions', 'id="action-form"') ?><?php } ?>
<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-truck"></i><?= lang('list_deliveries'); ?></h2>

        <div class="box-icon">
            <ul class="btn-tasks">
                <li class="dropdown">
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#"><i class="icon fa fa-tasks tip" data-placement="left" title="<?= lang("actions") ?>"></i></a>
                    <ul class="dropdown-menu pull-right" class="tasks-menus" role="menu" aria-labelledby="dLabel">
						<!--<li>
							<a href="#" id="completed_delivery" data-action="completed_delivery">
								<i class="fa fa-file-o" aria-hidden="true"></i> 
								<?= lang('delivery_completed') ?>
							</a>
						</li>
                        <li>
							<a id="deliveries_combine" href="javascript:void(0)">
								<i class="fa fa-heart"></i> <?= lang('Delivery Combine') ?>
							</a>
                        </li>-->
						<li>
							<a href="<?= site_url('sales/add_deliveries') ?>" id="add_delivery">
								<i class="fa fa-heart"></i> <?= lang('Add Delivery') ?>
							</a>
                        </li>
						
                        <li><a href="<?= site_url('sales') ?>"><i class="fa fa-heart"></i> <?= lang('list_sale') ?></a>
                        </li>
						<?php if ($Owner || $Admin) { ?>
							<li><a href="#" id="excel" data-action="export_excel"><i
										class="fa fa-file-excel-o"></i> <?= lang('export_to_excel') ?></a></li>
							<li><a href="#" id="pdf" data-action="export_pdf"><i
										class="fa fa-file-pdf-o"></i> <?= lang('export_to_pdf') ?></a>
							</li>
							<li>
								<a href="<?= site_url('sales/sale_by_csv'); ?>">
									<i class="fa fa-plus-circle"></i>
									<span class="text"> <?= lang('add_sale_by_csv'); ?></span>
								</a>
							</li>
						<?php }else{ ?>
							<?php if($GP['sales-export_delivery']) { ?>
								<li><a href="#" id="excel" data-action="export_excel"><i
										class="fa fa-file-excel-o"></i> <?= lang('export_to_excel') ?></a></li>
								<li><a href="#" id="pdf" data-action="export_pdf"><i
											class="fa fa-file-pdf-o"></i> <?= lang('export_to_pdf') ?></a>
								</li>
							<?php }?>
							<?php if($GP['sales-import_delivery']) { ?>
								<li>
									<a href="<?= site_url('sales/sale_by_csv'); ?>">
										<i class="fa fa-plus-circle"></i>
										<span class="text"> <?= lang('add_sale_by_csv'); ?></span>
									</a>
								</li>
							<?php }?>
						<?php }?>			
									
                        <li class="divider"></li>
                        <li><a href="#" class="bpo" title="<?= $this->lang->line("delete_deliveries") ?>"
                               data-content="<p><?= lang('r_u_sure') ?></p><button type='button' class='btn btn-danger' id='delete' data-action='delete'><?= lang('i_m_sure') ?></a> <button class='btn bpo-close'><?= lang('no') ?></button>"
                               data-html="true" data-placement="left"><i
                                    class="fa fa-trash-o"></i> <?= lang('delete_deliveries') ?></a></li>
                    </ul>
                </li>
            </ul>
        </div>
		
		<div class="box-icon">
            <div class="form-group choose-date hidden-xs">
                <div class="controls">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                        <input type="text"
                               value="<?= ($start ? $this->erp->hrld($start) : '') . ' - ' . ($end ? $this->erp->hrld($end) : ''); ?>"
                               id="daterange" class="form-control">
                        <span class="input-group-addon"><i class="fa fa-chevron-down"></i></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">
                <p class="introtext"><?= lang('list_results'); ?></p>
				
				<ul id="dbTab" class="nav nav-tabs">
					<?php if ($Owner || $Admin || $GP['sales-index']) { ?>
					<li class=""><a href="#sales"><?= lang('sale_delivery') ?></a></li>
					<?php } if ($Owner || $Admin || $GP['quotes-index']) { ?>
					<li class=""><a href="#quotes"><?= lang('sale_order_delivery') ?></a></li>
					<?php } ?>
				</ul>
						
				<div class="tab-content">
					<div id="sales" class="tab-pane fade in">
						<div class="row">
							<div class="col-sm-12">
								<div class="table-responsive">
									<table id="sale_item" class="table table-bordered table-hover table-striped table-condensed">
										<thead>
										<tr>
											<th style="min-width:30px; width: 30px; text-align: center;">
												<input class="checkbox checkft" type="checkbox" name="check"/>
											</th>
											<th><?php echo $this->lang->line("date"); ?></th>
											<th><?php echo $this->lang->line("do_reference_no"); ?></th>
											<th><?php echo $this->lang->line("sale_reference_no"); ?></th>
											<th><?php echo $this->lang->line("customer"); ?></th>
											<th><?php echo $this->lang->line("address"); ?></th>
											<th><?php echo $this->lang->line("quantity"); ?></th>
											<th style="width:150px"><?php echo $this->lang->line("status"); ?></th>
											<th style="width:100px; text-align:center;"><?php echo $this->lang->line("actions"); ?></th>
										</tr>
										</thead>
										<tbody>
										<tr>
											<td colspan="8" class="dataTables_empty"><?php echo $this->lang->line("loading_data"); ?></td>
										</tr>
										</tbody>
										<tfoot class="dtFilter">
										<tr class="active">
											<th style="min-width:30px; width: 30px; text-align: center;">
												<input class="checkbox checkft" type="checkbox" name="check"/>
											</th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th style="width:100px; text-align:center;"><?php echo $this->lang->line("actions"); ?></th>
										</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
					
					<div id="quotes" class="tab-pane fade in">
						<div class="row">
							<div class="col-sm-12">
								<div class="table-responsive">
									<table id="sale_order" class="table table-bordered table-hover table-striped table-condensed">
										<thead>
										<tr>
											<th style="min-width:30px; width: 30px; text-align: center;">
												<input class="checkbox checkft" type="checkbox" name="check"/>
											</th>
											<th><?php echo $this->lang->line("date"); ?></th>
											<th><?php echo $this->lang->line("do_reference_no"); ?></th>
											<th><?php echo $this->lang->line("sale_reference_no"); ?></th>
											<th><?php echo $this->lang->line("customer"); ?></th>
											<th><?php echo $this->lang->line("address"); ?></th>
											<th><?php echo $this->lang->line("quantity"); ?></th>
											<th style="width:150px"><?php echo $this->lang->line("status"); ?></th>
											<th style="width:100px; text-align:center;"><?php echo $this->lang->line("actions"); ?></th>
										</tr>
										</thead>
										<tbody>
										<tr>
											<td colspan="8" class="dataTables_empty"><?php echo $this->lang->line("loading_data"); ?></td>
										</tr>
										</tbody>
										<tfoot class="dtFilter">
										<tr class="active">
											<th style="min-width:30px; width: 30px; text-align: center;">
												<input class="checkbox checkft" type="checkbox" name="check"/>
											</th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th style="width:100px; text-align:center;"><?php echo $this->lang->line("actions"); ?></th>
										</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
					</div>
					
				</div>
            </div>
        </div>
    </div>
</div>
<?php if ($Owner) { ?>
    <div style="display: none;">
        <input type="hidden" name="form_action" value="" id="form_action"/>
        <?= form_submit('perform_action', 'perform_action', 'id="action-form-submit"') ?>
    </div>
    <?= form_close() ?>
    
<?php } ?>