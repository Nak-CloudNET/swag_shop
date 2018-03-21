<script>
    $(document).ready(function () {
        var oTable = $('#DOData').dataTable({
            "aaSorting": [[0, "asc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('sales/getSales_items').'/'.$start_date.'/'.$end_date ?>',
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
            }, null, null, null, {"mRender": currencyFormat},{"mRender": currencyFormat},{"mRender": currencyFormat},{"mRender": invoice_delivery_status}],
			"fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                var total_quantity = 0;
				var total_quantity_received=0;
				var total_balance = 0;
                for (var i = 0; i < aaData.length; i++) {
					total_quantity += parseFloat(aaData[aiDisplay[i]][4]);
					total_quantity_received+= parseFloat(aaData[aiDisplay[i]][5]);
					total_balance += parseFloat(aaData[aiDisplay[i]][6]);
                }
                var nCells = nRow.getElementsByTagName('th');
                nCells[4].innerHTML = currencyFormat(parseFloat(total_quantity));
				nCells[5].innerHTML = currencyFormat(parseFloat(total_quantity_received));
				nCells[6].innerHTML = currencyFormat(parseFloat(total_balance));
            }
        }).fnSetFilteringDelay().dtFilter([
			
			{column_number: 1, filter_default_label: "[<?=lang('sale_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 2, filter_default_label: "[<?=lang('customer');?>]", filter_type: "text", data: []},
			{column_number: 3, filter_default_label: "[<?=lang('saleman');?>]", filter_type: "text", data: []},
			{column_number: 7, filter_default_label: "[<?=lang('status');?>]", filter_type: "text", data: []},
        ], "footer");
		
		
		var oTable = $('#Sale_Order').dataTable({
            "aaSorting": [[0, "asc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('sales/getSaleOrderitems').'/'.$start_date.'/'.$end_date ?>',
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
            }, null, null, null, {"mRender": currencyFormat},{"mRender": currencyFormat},{"mRender": currencyFormat},{"mRender": sale_order_delivery_status}],
			"fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                var total_quantity = 0;
				var total_quantity_received=0;
				var total_balance = 0;
                for (var i = 0; i < aaData.length; i++) {
					total_quantity += parseFloat(aaData[aiDisplay[i]][4]);
					total_quantity_received+= parseFloat(aaData[aiDisplay[i]][5]);
					total_balance += parseFloat(aaData[aiDisplay[i]][6]);
                }
                var nCells = nRow.getElementsByTagName('th');
                nCells[4].innerHTML = currencyFormat(parseFloat(total_quantity));
				nCells[5].innerHTML = currencyFormat(parseFloat(total_quantity_received));
				nCells[6].innerHTML = currencyFormat(parseFloat(total_balance));
            }
        }).fnSetFilteringDelay().dtFilter([
			
			{column_number: 1, filter_default_label: "[<?=lang('sale_reference_no');?>]", filter_type: "text", data: []},
            {column_number: 2, filter_default_label: "[<?=lang('customer');?>]", filter_type: "text", data: []},
			{column_number: 3, filter_default_label: "[<?=lang('saleman');?>]", filter_type: "text", data: []},
			{column_number: 7, filter_default_label: "[<?=lang('status');?>]", filter_type: "text", data: []},
        ], "footer");
		
		
		
    });
	
</script>


<div class="row" style="margin-bottom: 15px;">
    <div class="col-md-12">
        <div class="box">
            <div class="box-header">
                <h2 class="blue"><i class="fa-fw fa fa-tasks"></i> <?= lang('Add_Deliveries') ?></h2>
            </div>
			<div class="box-content">
				<div class="row">
					<div class="col-md-12">
						<ul id="dbTab" class="nav nav-tabs">
							<?php if ($Owner || $Admin || $GP['sales-index']) { ?>
							<li class=""><a href="#sales"><?= lang('Invoice') ?></a></li>
							<?php } if ($Owner || $Admin || $GP['quotes-index']) { ?>
							<li class=""><a href="#quotes"><?= lang('Sale_Order') ?></a></li>
							<?php } ?>
						</ul>
						<div class="tab-content">
							<?php if ($Owner || $Admin || $GP['sales-index']) { ?>
								<div id="sales" class="tab-pane fade in">
									<div class="row">
										<div class="col-sm-12">
											<div class="table-responsive">
												<table id="DOData" class="table table-bordered table-hover table-striped table-condensed">
													<thead>
													<tr>
														<th style="min-width:30px; width: 30px; text-align: center;">
															<input class="checkbox checkft" type="checkbox" name="check"/>
														</th>
														
														<th><?php echo $this->lang->line("sale_reference_no"); ?></th>
														<th><?php echo $this->lang->line("customer"); ?></th>
														<th><?php echo $this->lang->line("saleman"); ?></th>
														<th><?php echo $this->lang->line("quantity"); ?></th>
														<th><?php echo $this->lang->line("quantity_received"); ?></th>
														<th><?php echo $this->lang->line("balance"); ?></th>
														
														<th style="width:150px"><?php echo $this->lang->line("status"); ?></th>
														
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
														</tr>
													</tfoot>
												</table>
											</div>
										</div>
								    </div>
								</div>

									<?php } if ($Owner || $Admin || $GP['quotes-index']) { ?>

									<div id="quotes" class="tab-pane fade">
										<div class="row">
											<div class="col-sm-12">
												<div class="table-responsive">
													<table id="Sale_Order" class="table table-bordered table-hover table-striped table-condensed">
														<thead>
														<tr>
															<th style="min-width:30px; width: 30px; text-align: center;">
																<input class="checkbox checkft" type="checkbox" name="check"/>
															</th>
															
															<th><?php echo $this->lang->line("sale_reference_no"); ?></th>
															<th><?php echo $this->lang->line("customer"); ?></th>
															<th><?php echo $this->lang->line("saleman"); ?></th>
															<th><?php echo $this->lang->line("quantity"); ?></th>
															<th><?php echo $this->lang->line("quantity_received"); ?></th>
															<th><?php echo $this->lang->line("balance"); ?></th>
															
															<th style="width:150px"><?php echo $this->lang->line("status"); ?></th>
															
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
															</tr>
														</tfoot>
													</table>
												</div>
											</div>
										</div>
									</div>
									
									<?php } ?>
						</div>
					</div>
				</div>
			</div>
        </div>
    </div>
</div>

