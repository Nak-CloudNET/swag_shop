<?php
	$v = "";
	if ($this->input->post('category_name')) {
		$v .= "&category_name=" . $this->input->post('category_name');
	}
	if (isset($sale_id)) {
		$v .= "&sale_id=" . $sale_id;
	}
	if($this->input->post('dates')){
		$getDate = $this->input->post('dates');
		$getDate_ = explode(" - ",$getDate[0]);
		$start_date   = $getDate_[0];
		$end_date     = $getDate_[1];
		
	}
?>
<script>
	$(document).ready(function(){
		$('#form').hide();
		$('.toggle_down').click(function () {
            $("#form").slideDown();
            return false;
        });
        $('.toggle_up').click(function () {
            $("#form").slideUp();
            return false;
        });
		var stockInhand = 0;
		$(".stockInHand").each(function() {
			stockInhand += parseFloat($(this).html());
		});
		$(".tdStockInhand").html(formatQuantity(stockInhand));
		
		
		var saleQuantity = 0;
		$(".saleQuantity").each(function() {
			saleQuantity += parseFloat($(this).html());
		});
		$(".tdsaleQuantity").html(formatQuantity(saleQuantity));
		
		var saleReturnQuantity = 0;
		$(".saleReturnQuantity").each(function() {
			saleReturnQuantity += parseFloat($(this).html());
		});
		$(".tdsaleReturnQuantity").html(formatQuantity(saleReturnQuantity));
		
		var unitCost = 0;
		$(".unitCost").each(function() {
			unitCost += parseFloat($(this).html());
		});
		$(".tdunitCost").html(formatMoney(unitCost));
		
		var unitPrice = 0;
		$(".unitPrice").each(function() {
			unitPrice += parseFloat($(this).html());
		});
		$(".tdunitPrice").html(formatMoney(unitPrice));
		
		var item_dis = 0;
		$(".item_dis").each(function() {
			item_dis += parseFloat($(this).html());
		});
		$(".tditem_dis").html(formatMoney(item_dis));
		
		var order_dis = 0;
		$(".order_dis").each(function() {
			order_dis += parseFloat($(this).html());
		});
		$(".tdorder_dis").html(formatMoney(order_dis));
		
		var revenue = 0;
		$(".revenue").each(function() {
			revenue += parseFloat($(this).html());
		});
		$(".tdrevenue").html(formatMoney(revenue));
		
		var coms = 0;
		$(".coms").each(function() {
			coms += parseFloat($(this).html());
		});
		$(".tdcoms").html(formatMoney(coms));
		
		var refund = 0;
		$(".refund").each(function() {
			refund += parseFloat($(this).html());
		});
		$(".tdrefund").html(formatMoney(refund));
		
		var profit = 0;
		$(".profit").each(function() {
			profit += parseFloat($(this).html());
		});
		
		$(".tdprofit").html(formatMoney(profit));
	});
</script>
<?php
	echo form_open('reports/saleReportDetail_actions', 'id="action-form"');
?>
<div class="box">
    <div class="box-header">
		<h2 class="blue"><i class="fa-fw fa fa-money"></i><?= lang('sales_report_detail'); ?></h2>   
		<div class="box-icon" style="">
            
			<div class="box-icon">
				<ul class="btn-tasks">
					<li class="dropdown"><a href="#" class="toggle_up tip" title="<?= lang('hide_form') ?>"><i
								class="icon fa fa-toggle-up"></i></a></li>
					<li class="dropdown"><a href="#" class="toggle_down tip" title="<?= lang('show_form') ?>"><i
								class="icon fa fa-toggle-down"></i></a></li>
				</ul>
			</div> 
			<div class="box-icon">
				<ul class="btn-tasks">
					<li class="dropdown"><a href="#" id="pdf" data-action="export_pdf" class="tip" title="<?= lang('download_pdf') ?>"><i class="icon fa fa-file-pdf-o"></i></a></li>
					<li class="dropdown"><a href="#" id="excel" data-action="export_excel" class="tip" title="<?= lang('download_xls') ?>"><i class="icon fa fa-file-excel-o"></i></a></li>				
				</ul>
			</div>
			<input type="hidden" id="datetime"  name="dates">			
		</div>
    </div>	
<?php if ($Owner) { ?>
    <div style="display: none;">
        <input type="hidden" name="form_action" value="" id="form_action"/>
        <?= form_submit('performAction', 'performAction', 'id="action-form-submit"') ?>
    </div>
    <?php echo form_close(); ?>
<?php } ?>
	<div class="box-content">
        <div class="row">
            <div class="col-lg-12">
                <p class="introtext"><?= lang('customize_report'); ?></p>
                <div id="form">
                    <?php echo form_open("reports/getSalesReportDetail"); ?>
					
                    <div class="row">
						<div class="col-sm-4">
							<div class="form-group choose-date hidden-xs" style="width:100%;">
								<?= lang("date", "date") ?>
								<div class="controls">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" value="<?= ($start > 0 && $end > 0 ? $start .' - '. $end : date('d/m/Y 00:00') . ' - ' . date('d/m/Y 23:59')) ?>" id="daterange" name ="daterange[]" class="form-control">
									</div>
								</div>
							</div>
						</div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("category_name", "category_name") ?>
                                <?php
                                $cat['0'] = lang("all");
                                foreach ($cate as $category) {
                                    $cat[$category->id] = $category->name;
                                }
                                echo form_dropdown('category_name', $cat, (isset($_POST['category_name']) ? $_POST['category_name'] : ''), 'class="form-control select" id="category_name" placeholder="' . lang("select") . " " . lang("category_name") . '" style="width:100%"')
                                ?>
                            </div>
                        </div>
						<div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("product_name", "product_name") ?>
                                <?php
                                $pro['0'] = lang("all");
                                foreach ($products as $product) {
                                    $pro[$product->id] = $product->name;
                                }
                                echo form_dropdown('product_name', $pro, (isset($_POST['product_name']) ? $_POST['product_name'] : ''), 'class="form-control select" id="category_name" placeholder="' . lang("select") . " " . lang("product_name") . '" style="width:100%"')
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

            </div>
        </div>
    </div>
	<div class="box-content">
        <div class="row">
		    <div class="col-lg-12" style="margin-top: -46px;">
			<?php 
				foreach($categories as $category){					
				?>					
					<div style="width:25%;border:1px solid #a9c8d6; height: 34px;padding-top:7px;background-color:#D9EDEF;padding-left:5px;"><input type="checkbox" name="check[]" value="<?= $category->id; ?>"/> <span style="color:blue;padding-left:10px;"><b><?= strtoupper($category->name);?></b></span></div>   
					<table class="table table-bordered table-hover table-striped table-condensed">
						<thead>
							<tr>						
								<th style="width: 227px;"><?php echo $this->lang->line("product_name"); ?></th>
								<th><?php echo $this->lang->line("stock_in_hand"); ?></th>
								<th><?php echo $this->lang->line("qty_sale"); ?></th>
								<th><?php echo $this->lang->line("qty_return"); ?></th>
								<th><?php echo $this->lang->line("unit_cost"); ?></th>
								<th><?php echo $this->lang->line("unit_price"); ?></th>
								<th><?php echo $this->lang->line('item_dis');?></th>
								<th><?php echo $this->lang->line('order_dis');?></th>
								<th><?php echo $this->lang->line("revenue"); ?></th>
								<th><?php echo $this->lang->line("coms"); ?></th>
								<th><?php echo $this->lang->line("refund"); ?></th>
								<th><?php echo $this->lang->line("profit"); ?></th>                       
							</tr>
						</thead>
						<tbody>	
							<?= $this->reports_model->getDataReportDetail($category->id,$start,$end)?>
						</tbody>
					</table>
				  <?php				
				}	
			?>
            </div>
        </div>
		<br/>
		<br/>
            <table class="table table-bordered table-hover table-striped table-condensed">
				<thead>
							<tr>						
								<th style="width: 227px;"><?php echo $this->lang->line("product_name"); ?></th>
								<th><?php echo $this->lang->line("stock_in_hand"); ?></th>
								<th><?php echo $this->lang->line("qty_sale"); ?></th>
								<th><?php echo $this->lang->line("qty_return"); ?></th>
								<th><?php echo $this->lang->line("unit_cost"); ?></th>
								<th><?php echo $this->lang->line("unit_price"); ?></th>
								<th><?php echo $this->lang->line('item_dis');?></th>
								<th><?php echo $this->lang->line('order_dis');?></th>
								<th><?php echo $this->lang->line("revenue"); ?></th>
								<th><?php echo $this->lang->line("coms"); ?></th>
								<th><?php echo $this->lang->line("refund"); ?></th>
								<th><?php echo $this->lang->line("profit"); ?></th>                       
							</tr>
				</thead>
				<tbody>	
							<tr style="background-color:#F2F5E9;text-align:center;font-weight:bold;">
								<td style="width:225px;">Total</td>
								<td class="tdStockInhand"></td>
								<td class="tdsaleQuantity"></td>
								<td class="tdsaleReturnQuantity"></td>
								<td class="tdunitCost"></td>
								<td class="tdunitPrice"></td>
								<td class="tditem_dis"></td>
								<td class="tdorder_dis"></td>
								<td class="tdrevenue"></td>
								<td class="tdcoms"></td>
								<td class="tdrefund"></td>
								<td class="tdprofit"></td>
							</tr>
					</tbody>
			</table>
    </div>
</div>
<script type="text/javascript">

         $('#excel').click( function(){
			var date = $('#daterange').val();
			  $('#datetime').val(date); 
		 });
		  $('#pdf').click( function(){
			var date = $('#daterange').val();
			  $('#datetime').val(date); 
		 });
		 
</script>