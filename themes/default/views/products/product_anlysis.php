<style type="text/css">
    @media print {
        #myModal .modal-content {
            display: none !important;
        }
    }
</style>
<div class="modal-dialog modal-lg no-modal-header">
    <div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-2x">&times;</i>
            </button>
			<h4 class="modal-title"><?=lang('product_anlysis');?></h4>
        </div>
        <div class="modal-body print">
			<!-- table show convert from items -->
			<div class="col-md-12">
				<div class="control-group table-group">
					<label class="table-label"><?= lang("convert_items_from"); ?></label>

					<div class="controls table-controls">
						<div class="table-responsive">
							<table cellpadding="0" cellspacing="0" border="0"
								   class="table table-bordered table-hover table-striped reports-table">
								<thead>
									<tr>
										<th><?= lang('name'); ?></th>
										<th><?= lang('quantity'); ?></th>
										<th><?= lang('cost'); ?></th>
										<th><?= lang('Total Cost'); ?></th>
										<th><?= lang('percentage'); ?></th>
									</tr>
								</thead>
								<tbody id="show_data">
									<?php
										$total_percent = '';
										$total_cost = '';
										$total_qty = '';
										$tcost = '';
										$tocost = '';
										foreach($deduct as $anlysis){
											$num = count($deduct);
											$percentage = 100 / $num;
											$total_percent +=$percentage;
											$total_cost = $anlysis->Ccost / $anlysis->Cquantity;
											$total_qty += $anlysis->Cquantity;
											$tcost += $total_cost;
											$tocost += $anlysis->Ccost;
									?>
									<tr>
										<td><?= $anlysis->product_name; ?></td>
										<td><?= $anlysis->Cquantity; ?></td>
										<td><?= $this->erp->formatMoney($total_cost);?></td>
										<td><?= $this->erp->formatMoney($anlysis->Ccost);?></td>
										<td><?= $percentage; ?>%</td>
									</tr>
									<?php
										}
									?>
								</tbody>
								<tfoot>
									<tr>
										<th><?= lang('total'); ?></th>
										<th><?= $this->erp->formatQuantity($total_qty);?></th>
										<th><?= $this->erp->formatQuantity($tcost);?></th>
										<th><?= $this->erp->formatQuantity($tocost);?></th>
										<th><?= $total_percent; ?>%</th>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- table show convert from items -->
			<div class="col-md-12">
				<div class="control-group table-group">
					<label class="table-label"><?= lang("convert_to_from"); ?></label>

					<div class="controls table-controls">
						<div class="table-responsive">
							<table cellpadding="0" cellspacing="0" border="0"
								   class="table table-bordered table-hover table-striped reports-table">
								<thead>
									<tr>
										<th><?= lang('name'); ?></th>
										<th><?= lang('quantity'); ?></th>
										<th><?= lang('cost'); ?></th>
										<th><?= lang('percentage'); ?></th>
									</tr>
								</thead>
								<tbody id="show_data">
									<?php
										$add_percent = '';
										$add_quantity = '';
										$add_cost = '';
										foreach($add as $total){
											$add_quantity += $total->Cquantity;
											$addCost += $total->Ccost;
											$add_cost = $addCost / $total->Cquantity;
										}
										foreach($add as $anlysis){
											$percentage = ($anlysis->Cquantity * 100) / $add_quantity;
											$cost = $anlysis->Ccost / $anlysis->Cquantity;
											$add_percent += $percentage;
									?>
									<tr>
										<td><?= $anlysis->product_name; ?></td>
										<td><?= $this->erp->formatQuantity($anlysis->Cquantity); ?></td>
										<td><?= $this->erp->formatQuantity($cost); ?></td>
										<td><?= $percentage; ?>%</td>
									</tr>
									<?php
										}
									?>
								</tbody>
								<tfoot>
									<tr>
										<th><?= lang('total')?></th>
										<th><?= $this->erp->formatQuantity($add_quantity);?></th>
										<th><?= $this->erp->formatQuantity($add_cost); ?></th>
										<th><?= $add_percent; ?>%</th>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div style="clear: both;"></div>
        </div>
    </div>
</div>