<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                <i class="fa fa-2x">&times;</i>
            </button>
            <button type="button" class="btn btn-xs btn-default no-print pull-right" style="margin-right:15px;" onclick="window.print();">
                <i class="fa fa-print"></i> <?= lang('print'); ?>
            </button>
            <h4 class="modal-title" id="myModalLabel"><?= lang('month_profit').' ('.$date.')'; ?></h4>
        </div>
        <div class="modal-body">
            <p><?= lang('unit_and_net_tip'); ?></p>
            <div class="table-responsive">
            <table width="100%" class="stable">
                <tr>
                    <td style="border-bottom: 1px solid #EEE;"><h4><?= lang('products_sale'); ?>:</h4></td>
                    <td style="text-align:right; border-bottom: 1px solid #EEE;">
                            <h4><span><?= '('.$this->erp->formatQuantity($costing->total_items).')'.$this->erp->formatMoney($costing->no_total); ?></span></h4>
                    </td>
                </tr>
                <tr>
                    <td style="border-bottom: 1px solid #DDD;"><h4><?= lang('order_discount'); ?>:</h4></td>
                    <td style="text-align:right;border-bottom: 1px solid #DDD;">
                        <h4>
                            <span><?php $discount = $discount ? $discount->order_discount : 0; echo $this->erp->formatMoney($discount); ?></span>
                        </h4>
                    </td>
                </tr>
                <tr>
                    <td width="300px;" style="font-weight:bold;"><h4><?= lang('products_return'); ?>:</h4>
                    </td>
                    <td style="text-align:right;"><h4>
                            <span><?= '('.$this->erp->formatQuantity($returns->quantity).')'.$this->erp->formatMoney($returns->total); ?></span>
                        </h4></td>
                </tr>
				<?php 
					$net_price = $costing->no_total - $discount - $returns->total;
				?>
				<tr>
                    <td width="300px;" style="font-weight:bold;"><h4><strong><?= lang('net_price'); ?>:</strong></h4>
                    </td>
                    <td style="text-align:right;"><h4><strong><span><?= '('.$this->erp->formatQuantity($costing->total_items - $returns->quantity).')'.$this->erp->formatMoney($net_price); ?></span></strong></h4></td>
                </tr>
                <tr>
                    <td style="border-bottom: 1px solid #EEE;"><h4><?= lang('products_cost'); ?>:</h4></td>
                    <td style="text-align:right; border-bottom: 1px solid #EEE;">
                        <h4><span><?= '('.$this->erp->formatQuantity($costing->total_items - $returns->quantity).')'.$this->erp->formatMoney($costing->cost); ?></span></h4>
                    </td>
                </tr>
                <tr>
                    <td width="300px;" style="font-weight:bold;"><h4><strong><?= lang('profit'); ?></strong>:</h4>
                    </td>
                    <td style="text-align:right;">
                        <h4>
                            <span><strong><?= $this->erp->formatMoney($net_price - $costing->cost); ?></strong></span>
                        </h4>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </div>

</div>
