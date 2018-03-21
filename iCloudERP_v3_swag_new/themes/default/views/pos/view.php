 <?php
function product_name($name)
{
    return character_limiter($name, (isset($pos_settings->char_per_line) ? ($pos_settings->char_per_line-8) : 35));
}

if ($modal) {
    echo '<div class="modal-dialog no-modal-header"><div class="modal-content"><div class="modal-body"><button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-2x">&times;</i></button>';
} else { ?>
    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <title><?= $page_title . " " . lang("no") . " " . $inv->id; ?></title>
        <base href="<?= base_url() ?>"/>
        <meta http-equiv="cache-control" content="max-age=0"/>
        <meta http-equiv="cache-control" content="no-cache"/>
        <meta http-equiv="expires" content="0"/>
        <meta http-equiv="pragma" content="no-cache"/>
        <link rel="shortcut icon" href="<?= $assets ?>images/icon.png"/>
        <link rel="stylesheet" href="<?= $assets ?>styles/theme.css" type="text/css"/>
        <style type="text/css" media="all">
            body {
                color: #000;
            }

            #wrapper {
                max-width: 480px;
                margin: 0 auto;
                padding-top: 20px;
            }

            .btn {
                border-radius: 0;
                margin-bottom: 5px;
            }

            h3 {
                margin: 5px 0;
            }
			
			.text-center {
				text-align:center;
			}
			
			.item td {
				border-bottom: 1px solid #000;
			}
			.receipt > thead > tr > th {
				font-size: 15px;
				background-color:#fff !important;color:#000 !important;
				-webkit-print-color-adjust: exact; 
				-moz-print-color-adjust: exact;
				-ms-print-color-adjust:exact;
				print-color-adjust:exact;
				color-adjust:exact;
				-webkit-color-adjust:exact;
				-moz-color-adjust:exact;
				-ms-color-adjust:exact;
			}

            @media print {
                .no-print {
                    display: none;
                }

                #wrapper {
                    max-width: 480px;
                    width: 100%;
                    min-width: 250px;
                    margin: 0 auto;
                }
				
			}
			.font_para{
					font-size:15px!important;
			}
        </style>

    </head>

    <body>

<?php } ?>
<div id="wrapper">
    <div id="receiptData">
    <div class="no-print">
        <?php if ($message) { ?>
            <div class="alert alert-success">
                <button data-dismiss="alert" class="close" type="button">×</button>
                <?= is_array($message) ? print_r($message, true) : $message; ?>
            </div>
        <?php } ?>
    </div>
    <div id="receipt-data">
        <div class="text-center">
            <button class="btn btn-xs btn-default no-print pull-left" onclick="window.print()"><i class="fa fa-print"></i>&nbsp;<?= lang("print"); ?></button>
			<img src="<?= base_url() . 'assets/uploads/logos/' . $biller->logo; ?>" alt="<?= $biller->company; ?>"> 
			<!--<h3 style="text-transform:uppercase;"><?= $biller->company != '-' ? $biller->company : $biller->name; ?></h3>-->
            <?php
            echo "<p class='font_para'>" . $biller->address . " " . $biller->city . " " . $biller->postal_code . " " . $biller->state . " " . $biller->country .
                "<br><b>" . lang("tel") . ": " . $biller->phone . "</b>, "; 
            ?>
            <?php
            /*
            if ($pos_settings->cf_title2 != "" && $pos_settings->cf_value2 != "") {
                echo $pos_settings->cf_title2 . ": " . $pos_settings->cf_value2 . ", ";
            }
            if ($pos_settings->cf_title1 != "" && $pos_settings->cf_value1 != "") {
                echo $pos_settings->cf_title1 . ": " . $pos_settings->cf_value1 . "<br>";
            } */
            echo '</p></div>';
            
            if ($Settings->invoice_view == 1) { ?>
                <div class="col-sm-12 text-center">
                    <h4 style="font-weight:bold;"><?= lang('tax_invoice'); ?></h4>
                </div>
            <?php } 
			if($pos_settings->in_out_rate){
				echo '<div class="col-xs-6 font_para">';
					echo lang("time_in") . " : " . $this->erp->hrld($inv->date) . "<br>";
				echo '</div>';
				echo '<div class="col-xs-6 font_para">';
					echo lang("<p style='float:left;margin:0px'>invoice") . " : " . $inv->reference_no . "</p><br>";
				echo '</div>';
			}else{
				echo '<div class="col-xs-6 font_para">';
					echo lang("suspend") . " : " . $inv->suspend_note . "<br>";
					echo lang("time_in") . " : " . $this->erp->hrld($inv->date) . "<br>";
					echo lang("time_out") . " : " . $this->erp->hrld($inv->date);
				echo '</div>';
				echo '<div class="col-xs-6 font_para">';
					echo lang("<p style='float:left;margin:0px'>invoice") . " : " . $inv->reference_no . "</p><br>";
					echo lang("username") . " : " . $inv->username . "<br>";
					echo lang("customer") . " : " . $inv->customer;
				echo '</div>';
			}
			$total_disc = 0;
			foreach ($rows as $d) {
				
				if($d->discount != 0){
					$total_disc = $d->discount;
				}
			}
            ?>
			
            <div style="clear:both;padding-bottom: 8px;"></div>
            <table class="table table-striped table-condensed receipt h" style="font-size:15px !important">
				<thead>
					<tr>
						<th><?= lang("no"); ?></th>
						<th><?= lang("description"); ?></th>
						<th><?= lang("serial"); ?></th>
						<th><?= lang("qty"); ?></th>
						<th style="padding-left: 14px;"><?= lang("unit"); ?></th>
						<?php if ($inv->order_discount != 0 || $total_disc != '') {
							echo '<th>'.lang('discount').'</th>';
						} ?>
						<th style="padding-left:10px;padding-right:10px;"><?= lang("amount"); ?> </th>
					</tr>
				</thead>
                <tbody>
                <?php
					$r = 1;
					$m_us = 0;
					$total_quantity = 0;
					$tax_summary = array();
					
					$sub_total = 0;
					
					foreach ($rows as $row) {
                        $free = lang('free');

						//$this->erp->print_arrays($row);
						if (isset($tax_summary[$row->tax_code])) {
							$tax_summary[$row->tax_code]['items'] += $row->quantity;
							$tax_summary[$row->tax_code]['tax'] += $row->item_tax;
							$tax_summary[$row->tax_code]['amt'] += ($row->quantity * $row->net_unit_price) - $row->item_discount;
						} else {
							$tax_summary[$row->tax_code]['items'] = $row->quantity;
							$tax_summary[$row->tax_code]['tax'] = $row->item_tax;
							$tax_summary[$row->tax_code]['amt'] = ($row->quantity * $row->net_unit_price) - $row->item_discount;
							$tax_summary[$row->tax_code]['name'] = $row->tax_name;
							$tax_summary[$row->tax_code]['code'] = $row->tax_code;
							$tax_summary[$row->tax_code]['rate'] = $row->tax_rate;
						}

						echo '<tr ' . ($row->product_type === 'combo' ? '' : 'class="item"') . '>
								<td class="text-left">#' . $r . "</td>";
						echo '	<td class="text-left">' . product_name($row->product_name) . ($row->variant ? ' (' . $row->variant . ')' : '') . '</td>';
						echo '	<td style="text-align:left;">' . $row->serial_no . '</td>';
						echo '	<td class="text-center">' . $this->erp->formatQuantity($row->quantity) . '</td>';
						
						echo '	<td class="text-center">' . $this->erp->formatMoney($row->unit_price) . '</td>';
						//echo '<hr/>';
						$colspan = 5;
						if ($inv->order_discount != 0 || $row->item_discount != 0) {
						echo '	<td class="text-center">';
							echo 	'<span>' ;
								if(strpos($row->discount, '%') !== false){
									echo $row->discount;
								}else{
									echo $row->discount;
								}
								/*
									if(strpos($inv->order_discount_id, '%') !== false){
										echo $inv->order_discount_id;
									}else{
										echo $inv->order_discount_id . '%';
									}
									*/
								
							echo '</span> ';
							$colspan = 6;
							$total_col = 3;
							$total_colspan=2;
							$total_cols = 6;
							echo '</td>';
						}else{
							if($total_disc != ''){
								echo '<td class="text-center"></td>';
								$colspan = 6;
								$total_col = 2;
								$total_cols = 2;
							}else{
								$colspan = 5;
								$total_col = 2;
								$total_cols =5;
								$total_colspan=2;
							}
						}
						echo '<td class="text-right">' . ($this->erp->formatMoney($row->subtotal) == 0 ? $free:$this->erp->formatMoney($row->subtotal)) . '</td>';
						$r++;
						$total_quantity += $row->quantity;
						if($row->product_type === 'combo')
						{
							$this->db->select('*, (select name from erp_products p where p.id = erp_combo_items.product_id) as p_name ');
							$this->db->where('erp_combo_items.product_id = "' . $row->product_id . '"');
							$comboLoop = $this->db->get('erp_combo_items');
							$c = 1;
							$cTotal = count($comboLoop->result());
							foreach ($comboLoop->result() as $val) {
							echo '<tr ' . ($c === $cTotal ? 'class="item"' : '') . '>';
								echo '<td></td>';
								echo '<td><span style="padding-right: 5px;">' . $c . '. ' . $val->p_name . '</span></td>';
								echo '<td class="text-center"></td>';
								echo '<td class="text-center"></td>';
								echo '<td></td>';
								echo '<td></td>';
							echo '</tr>';
								$c++;
							}
						}
						
						$sub_total+=$row->subtotal;
					}
                ?>
                </tbody>
                <tfoot>
					<tr>
						<th></th>
						<th colspan="<?= $total_colspan;?>">
							<?php 
								if($exchange_rate_kh_c->rate == 0){
									
								}else{
								if($pos_settings->in_out_rate == 0 or $pos_settings->in_out_rate == ""){
									echo lang("exchange_rate"); ?> : <?php echo $exchange_rate_kh_c->rate?number_format($exchange_rate_kh_c->rate):0 .' ៛ |'; 
								}
								}
							?>
							<?= lang("qty"); ?>= (<?=$this->erp->formatQuantity($total_quantity)?>)
						</th>
						<th colspan="<?=$total_col?>" class="text-right"><?= lang("total_usd"); ?></th>
						<th class="text-right"><?= $this->erp->formatMoney($sub_total); ?></th>
					</tr>
					<tr>
						
						<th colspan="<?=$total_cols?>" class="text-right"><?= lang("total_khm"); ?></th>
						<th class="text-right">
							<?php $total_khm = ($exchange_rate_kh_c->rate) * ($sub_total); ?>
							<?= number_format($total_khm).'៛';?>
						</th>
					</tr>
                <?php
                if ($inv->order_tax != 0) {
                    echo '<tr><th colspan="' . $colspan . '" class="text-right">' . lang("tax") . '</th>';
					echo '<th class="text-right">' . $this->erp->formatMoney($inv->order_tax) . '</th></tr>';
                }
                if ($inv->order_discount != 0) {
                    echo '<tr><th colspan="' . $colspan . '" class="text-right" style="border-top:2px dotted #ddd;padding-right: 12px;">' . lang("order_discount") . '(' . (strpos($inv->order_discount_id, '%')?$inv->order_discount_id:$inv->order_discount_id . '%') . ')</th><th style="border-top:2px dotted #ddd #ddd" class="text-right">'.$this->erp->formatMoney($inv->order_discount) . '</th></tr>';
                }
				if($pos_settings->in_out_rate){
					$amount_kh_to_us = ($inv->other_cur_paid != null ? $inv->other_cur_paid/$outexchange_rate->rate : 0);
				}else{
					$amount_kh_to_us = ($inv->other_cur_paid != null ? $inv->other_cur_paid/$exchange_rate->rate : 0);
				}
				
                if ($pos_settings->rounding) { 
                    $round_total = $this->erp->roundNumber($inv->grand_total, $pos_settings->rounding);
                    $rounding = $this->erp->formatMoney($round_total - $inv->grand_total);
                ?>
                    <tr>
                        <th style="border-top:2px dotted #000; padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("rounding"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= $rounding; ?></th>
                    </tr>
					
					<?php if ($inv->order_discount != 0 || $inv->order_tax != 0) { ?>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("grand_total"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= $this->erp->formatMoney($inv->grand_total + $rounding); ?></th>
                    </tr>
                <?php 
					}
				} else { ?>
				<?php if ($inv->order_discount != 0 || $inv->order_tax != 0) { ?>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("grand_total_usd"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= $this->erp->formatMoney($inv->grand_total); ?></th>
                    </tr>
					<tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("grand_total_khm"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right">
							<?php $grand_total_khm = ($exchange_rate_kh_c->rate)*($inv->grand_total); ?>
							<?= number_format($grand_total_khm).'៛';?>
						</th>
                    </tr>
                <?php }
                        if ($inv->shipping != 0) { ?>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("shipping"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= $this->erp->formatMoney($inv->shipping); ?></th>
                    </tr>
                <?php }
				}
				$pos_paid = 0;
				if($payments){
					
					foreach($payments as $payment) {
						$pos_paid = $payment->pos_paid;
					}
				}
				if($pos_paid >= $inv->grand_total){
					if(count($payments) > 1){
						
					?>
					<tr>
						<th colspan="<?= $colspan + 1 ?>">
				<?php 
					foreach($payments as $payment) {
				?>
					<table style="width:100%;">
						<caption style="float: left; padding-left: 13px;">
							<?= lang('paid_by').' '.lang($payment->paid_by);?>
						</caption>
						<tr>
							<th style="border:2px solid #000;border-right:none;padding-right: 12px;width:81%;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_us"); 
							
							
							?></th>
							<th style="border:2px solid #000;border-left:none;" class="text-right"><?= $this->erp->formatMoney($payment->pos_paid); ?></th>
						</tr>
						<?php
							if($inv->other_cur_paid){
						?>
						<tr>
							<th style="border:2px solid #000;border-right:none;padding-right: 12px;width:81%;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_kh"); ?></th>
							<th style="border:2px solid #000;border-left:none;" class="text-right"><?= $inv->other_cur_paid . '  ៛' ; ?></th>
						</tr>
						<?php
							}else{}
						?>
					</table>
				<?php
					}
				?>
						</th>
					</tr>
					<?php 
					}else{
				?>
					<tr>
                        <th style="border:2px solid #000;border-right:none;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount"); ?>(<?= $default_currency->code; ?>)</th>
                        <th style="border:2px solid #000;border-left:none;" class="text-right"><?= $this->erp->formatMoney($pos_paid); ?></th>
                    </tr>
                    <tr>
                        <th style="border:2px solid #000;border-right:none;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_kh"); ?></th>
                        <th style="border:2px solid #000;border-left:none;" class="text-right"><?= $inv->other_cur_paid  . '៛' ; ?></th>
                    </tr>
					
					<?php 
					}
					if(count($payments) > 1){
						$pay = '';
						$pay_kh = '';
						foreach($payments as $payment) {
							$pay += $payment->pos_paid;
							$pay_kh += $payment->pos_paid_other;
						}
						if((($pay + ($pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate : $exchange_rate->rate))) - $inv->grand_total) != 0){ 
						
				?>
					<tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_us"); 
						
							
						?></th>
                        <th style="border-top:2px dotted #000" class="text-right">
						<?php
							echo $this->erp->formatMoney(($pay+$pay_kh) - $inv->grand_total);
							$total_us_b = $this->erp->formatMoney(($pay+$pay_kh) - $inv->grand_total);
							$m_us = $this->erp->fraction($total_us_b);
						?>
						</th>
                    </tr>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_kh"); ?></th>
						<th style="border-top:2px dotted #000" class="text-right"><?= number_format(round((($pay+$pay_kh) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate)), -3) . '៛' ; ?></th>
                    </tr>
				<?php
						}
					}else{
					if((($pos_paid+$amount_kh_to_us) - $inv->grand_total) != 0 && ($this->erp->formatMoney((($pos_paid+$amount_kh_to_us) - $inv->grand_total)*$exchange_rate->rate )) != 0){ ?>
					<tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_us"); 
							;?></th>
                        <th style="border-top:2px dotted #000" class="text-right">
						<?php
							echo $this->erp->formatMoney(($pos_paid+$amount_kh_to_us) - $inv->grand_total);
							$total_us_b = $this->erp->formatMoney(($pos_paid+$amount_kh_to_us) - $inv->grand_total);
							$m_us = $this->erp->fraction($total_us_b);
						?>
						</th>
                    </tr>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_kh"); ?></th>
						<th style="border-top:2px dotted #000" class="text-right"><?= number_format(round((($pos_paid+$amount_kh_to_us) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate)), -3) . '៛' ; ?></th>
                    </tr>
				
					<?php
					}
					}
				}
                if ($pos_paid < $inv->grand_total) { 
					//separate payments
					if(count($payments) > 1){
				?>
					<tr>
						<th colspan="<?= $colspan + 1 ?>">
				<?php 
					foreach($payments as $payment) {
				?>
					<table style="width:100%;">
						<caption style="float: left; padding-left: 13px;"><?= lang('paid_by').' '.lang($payment->paid_by);?></caption>
						<tr>
							<th style="border:2px solid #000;border-right:none;padding-right: 12px;width:81%;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_us"); 
							?></th>
							<th style="border:2px solid #000;border-left:none;" class="text-right"><?= $this->erp->formatMoney($payment->pos_paid); ?></th>
						</tr>
						<?php
							if($inv->other_cur_paid){
						?>
						<tr>
							<th style="border:2px solid #000;border-right:none;padding-right: 12px;width:81%;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_kh"); ?></th>
							<th style="border:2px solid #000;border-left:none;" class="text-right"><?= $inv->other_cur_paid . '  ៛' ; ?></th>
						</tr>
						<?php
							}else{}
						?>
					</table>
				<?php
					}
				?>
						</th>
					</tr>
				<?php 
					}else{
				?>
					<tr>
                        <th style="border:2px solid #000;border-right:none;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_us"); 
						
							;?></th>
                        <th style="border:2px solid #000;border-left:none;" class="text-right"><?= $this->erp->formatMoney($pos_paid); ?></th>
                    </tr>
					<?php
						if($inv->other_cur_paid){
					?>
                    <tr>
                        <th style="border:2px solid #000;border-right:none;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("paid_amount_kh"); ?></th>
                        <th style="border:2px solid #000;border-left:none;" class="text-right"><?= $inv->other_cur_paid . '  ៛' ; ?></th>
                    </tr>
					<?php
						}else{}
					?>
				<?php
					}
					
					if(count($payments) > 1){
						
						$pay = '';
						$pay_kh = '';
						foreach($payments as $payment) {
							$pay += $payment->pos_paid;
							$pay_kh += $payment->pos_paid_other;
						}
						
						
						if((($pay + ($pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) - $inv->grand_total) > 0){ 
				?>
					<tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_us"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right">
						<?php
							$money_kh = $pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate);
							echo $this->erp->formatMoney(abs(($pay+$money_kh) - $inv->grand_total));
							$total_us_b = $this->erp->formatMoney(($pay+$money_kh) - $inv->grand_total);
							$m_us = $this->erp->fraction($total_us_b);
						?>
						</th>
                    </tr>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_kh"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= number_format(abs((($pay+$money_kh) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) . ' ៛' ; ?></th>
                    </tr>
				<?php
						}
					}else{
						
						
					if((($pos_paid+$amount_kh_to_us) - $inv->grand_total) > 0 && ($this->erp->formatMoney((($pos_paid+$amount_kh_to_us) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate) )) > 0){ ?>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_us"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right">
						<?php
							echo $this->erp->formatMoney(abs(($pos_paid+$amount_kh_to_us) - $inv->grand_total));
							$total_us_b = $this->erp->formatMoney(($pos_paid+$amount_kh_to_us) - $inv->grand_total);
							$m_us = $this->erp->fraction($total_us_b);
						?>
						</th>
                    </tr>
                    <tr>
                        <th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("change_amount_kh"); ?></th>
                        <th style="border-top:2px dotted #000" class="text-right"><?= number_format(abs((($pos_paid+$amount_kh_to_us) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) . ' ៛' ; ?></th>
                    </tr>
				
				<?php }else{
					
				
						$pay = '';
						$pay_kh = '';
						foreach($payments as $payment) {
							$pay += $payment->pos_paid;
							$pay_kh += $payment->pos_paid_other;
						}
				
				
						if((($pay + ($pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) - $inv->grand_total) < 0){
							
						?>
								
							 <tr>
								<th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_us"); ?></th>
								<th style="border-top:2px dotted #000" class="text-right">
								<?php
									$money_kh = $pay_kh / (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate);
									echo $this->erp->formatMoney(abs(($pay+$money_kh) - $inv->grand_total));
									$total_us_b = $this->erp->formatMoney(($pay+$money_kh) - $inv->grand_total);
									$m_us = $this->erp->fraction($total_us_b);
								?>
								</th>
							</tr>
							<tr>
								<th style="border-top:2px dotted #000;padding-right: 12px;" colspan="<?= $colspan ?>" class="text-right"><?= lang("remaining_kh"); ?></th>
								<th style="border-top:2px dotted #000" class="text-right"><?= number_format(abs((($pay+$money_kh) - $inv->grand_total)*(($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate))) . ' ៛' ; ?></th>
							</tr>
							
							
						<?php
						}
					}
				  }
				}
				?>
                </tfoot>
            </table>
			<!--<div class="alert alert-success">
				<?php $rate = (($pos_settings->in_out_rate) ? $outexchange_rate->rate:$exchange_rate->rate); ?>
				<h4>US <?=$this->erp->fraction($pos_paid)?> = <?=number_format($this->erp->fraction($pos_paid)*$rate)?> ៛</h4>
			</div>-->
            <?php
            if ($Settings->invoice_view == 1) {
                if (!empty($tax_summary)) {
                    echo '<h4 style="font-weight:bold;">' . lang('tax_summary') . '</h4>';
                    echo '<table class="table table-condensed"><thead><tr><th>' . lang('name') . '</th><th>' . lang('code') . '</th><th>' . lang('qty') . '</th><th>' . lang('tax_excl') . '</th><th>' . lang('tax_amt') . '</th></tr></td><tbody>';
                    foreach ($tax_summary as $summary) {
                        echo '<tr><td>' . $summary['name'] . '</td><td class="text-center">' . $summary['code'] . '</td><td class="text-center">' . $this->erp->formatQuantity($summary['items']) . '</td><td class="text-right">' . $this->erp->formatMoney($summary['amt']) . '</td><td class="text-right">' . $this->erp->formatMoney($summary['tax']) . '</td></tr>';
                    }
                    echo '</tbody></tfoot>';
                    echo '<tr><th colspan="4" class="text-right">' . lang('total_tax_amount') . '</th><th class="text-right">' . $this->erp->formatMoney($inv->product_tax) . '</th></tr>';
                    echo '</tfoot></table>';
                }
            }
            ?>

            <?= $inv->note ? '<p class="text-left"><strong>'.lang("note").': '. $this->erp->decode_html($inv->note) . '</strong></p>' : ''; ?>
            <?= $inv->staff_note ? '<p class="no-print"><strong>' . lang('staff_note') . ':</strong> ' . $this->erp->decode_html($inv->staff_note) . '</p>' : ''; ?>
            <div class="well well-sm text-center">
                <?= $this->erp->decode_html($biller->invoice_footer); ?>
            </div>
        </div>
        <div style="clear:both;"></div>
    </div>
<?php if ($modal) {
    echo '</div></div></div></div>';
} else { ?>
<div id="buttons" style="padding-top:10px; text-transform:uppercase;" class="no-print">
    <hr>
    <?php if ($message) { ?>
    <div class="alert alert-success">
        <button data-dismiss="alert" class="close" type="button">×</button>
        <?= is_array($message) ? print_r($message, true) : $message; ?>
    </div>
<?php } ?>

    <?php if ($pos_settings->java_applet) { ?>
        <span class="col-xs-12"><a class="btn btn-block btn-primary" onClick="printReceipt()"><?= lang("print"); ?></a></span>
        <span class="col-xs-12"><a class="btn btn-block btn-info" type="button" onClick="openCashDrawer()">Open Cash
                Drawer</a></span>
        <div style="clear:both;"></div>
    <?php } else { ?>
        <span class="pull-right col-xs-12">
        <a href="javascript:window.print()" id="web_print" class="btn btn-block btn-primary"
           onClick="window.print();return false;"><?= lang("web_print"); ?></a>
    </span>
    <?php } ?>


    <span class="col-xs-12">
        <a class="btn btn-block btn-warning" href="<?= site_url('pos'); ?>"><?= lang("back_to_pos"); ?></a>
    </span>
    <?php if (!$pos_settings->java_applet) { ?>
        <div style="clear:both;"></div>
        <div class="col-xs-12" style="background:#F5F5F5; padding:10px;">
            <p style="font-weight:bold;">Please don't forget to disble the header and footer in browser print
                settings.</p>

            <p style="text-transform: capitalize;"><strong>FF:</strong> File &gt; Print Setup &gt; Margin &amp;
                Header/Footer Make all --blank--</p>

            <p style="text-transform: capitalize;"><strong>chrome:</strong> Menu &gt; Print &gt; Disable Header/Footer
                in Option &amp; Set Margins to None</p></div>
    <?php } ?>
    <div style="clear:both;"></div>

</div>

</div>
<canvas id="hidden_screenshot" style="display:none;">

</canvas>
<div class="canvas_con" style="display:none;"></div>
<script type="text/javascript" src="<?= $assets ?>pos/js/jquery-1.7.2.min.js"></script>
<?php if ($pos_settings->java_applet) {
        function drawLine()
        {
            $size = $pos_settings->char_per_line;
            $new = '';
            for ($i = 1; $i < $size; $i++) {
                $new .= '-';
            }
            $new .= ' ';
            return $new;
        }

        function printLine($str, $sep = ":", $space = NULL)
        {
            $size = $space ? $space : $pos_settings->char_per_line;
            $lenght = strlen($str);
            list($first, $second) = explode(":", $str, 2);
            $new = $first . ($sep == ":" ? $sep : '');
            for ($i = 1; $i < ($size - $lenght); $i++) {
                $new .= ' ';
            }
            $new .= ($sep != ":" ? $sep : '') . $second;
            return $new;
        }

        function printText($text)
        {
            $size = $pos_settings->char_per_line;
            $new = wordwrap($text, $size, "\\n");
            return $new;
        }

        function taxLine($name, $code, $qty, $amt, $tax)
        {
            return printLine(printLine(printLine(printLine($name . ':' . $code, '', 18) . ':' . $qty, '', 25) . ':' . $amt, '', 35) . ':' . $tax, ' ');
        }

        ?>

        <script type="text/javascript" src="<?= $assets ?>pos/qz/js/deployJava.js"></script>
        <script type="text/javascript" src="<?= $assets ?>pos/qz/qz-functions.js"></script>
        <script type="text/javascript">
            deployQZ('themes/<?=$Settings->theme?>/assets/pos/qz/qz-print.jar', '<?= $assets ?>pos/qz/qz-print_jnlp.jnlp');
            usePrinter("<?= $pos_settings->receipt_printer; ?>");
            <?php /*$image = $this->erp->save_barcode($inv->reference_no);*/ ?>
            function printReceipt() {
                //var barcode = 'data:image/png;base64,<?php /*echo $image;*/ ?>';
                receipt = "";
                receipt += chr(27) + chr(69) + "\r" + chr(27) + "\x61" + "\x31\r";
                receipt += "<?= $biller->company; ?>" + "\n";
                receipt += " \x1B\x45\x0A\r ";
                receipt += "<?= $biller->address . " " . $biller->city . " " . $biller->country; ?>" + "\n";
                receipt += "<?= $biller->phone; ?>" + "\n";
                receipt += "<?php if ($pos_settings->cf_title1 != "" && $pos_settings->cf_value1 != "") { echo printLine($pos_settings->cf_title1 . ": " . $pos_settings->cf_value1); } ?>" + "\n";
                receipt += "<?php if ($pos_settings->cf_title2 != "" && $pos_settings->cf_value2 != "") { echo printLine($pos_settings->cf_title2 . ": " . $pos_settings->cf_value2); } ?>" + "\n";
                receipt += "<?=drawLine();?>\r\n";
                receipt += "<?php if($Settings->invoice_view == 1) { echo lang('tax_invoice'); } ?>\r\n";
                receipt += "<?php if($Settings->invoice_view == 1) { echo drawLine(); } ?>\r\n";
                receipt += "\x1B\x61\x30";
                receipt += "<?= printLine(lang("reference_no") . ": " . $inv->reference_no) ?>" + "\n";
                receipt += "<?= printLine(lang("sales_person") . ": " . $biller->name); ?>" + "\n";
                receipt += "<?= printLine(lang("customer") . ": " . $inv->customer); ?>" + "\n";
                receipt += "<?= printLine(lang("date") . ": " . date($dateFormats['php_ldate'], strtotime($inv->date))) ?>" + "\n\n";
                receipt += "<?php $r = 1;
            foreach ($rows as $row): ?>";
                receipt += "<?= "#" . $r ." "; ?>";
                receipt += "<?= printLine(product_name(addslashes($row->product_name)).($row->variant ? ' ('.$row->variant.')' : '').":".$row->tax_code, '*'); ?>" + "\n";
                receipt += "<?= printLine($this->erp->formatQuantity($row->quantity)."x".$this->erp->formatMoney($row->net_unit_price+($row->item_tax/$row->quantity)) . ":  ". $this->erp->formatMoney($row->subtotal), ' ') . ""; ?>" + "\n";
                receipt += "<?php $r++;
            endforeach; ?>";
                receipt += "\x1B\x61\x31";
                receipt += "<?=drawLine();?>\r\n";
                receipt += "\x1B\x61\x30";
                receipt += "<?= printLine(lang("total") . ": " . $this->erp->formatMoney($inv->total+$inv->product_tax)); ?>" + "\n";
                <?php if ($inv->order_tax != 0) { ?>
                receipt += "<?= printLine(lang("tax") . ": " . $this->erp->formatMoney($inv->order_tax)); ?>" + "\n";
                <?php } ?>
                <?php if ($inv->total_discount != 0) { ?>
                receipt += "<?= printLine(lang("discount") . ": (" . $this->erp->formatMoney($inv->product_discount).") ".$this->erp->formatMoney($inv->order_discount)); ?>" + "\n";
                <?php } ?>
                <?php if($pos_settings->rounding) { ?>
                receipt += "<?= printLine(lang("rounding") . ": " . $rounding); ?>" + "\n";
                receipt += "<?= printLine(lang("grand_total") . ": " . $this->erp->formatMoney($this->erp->roundMoney($inv->grand_total+$rounding))); ?>" + "\n";
                <?php } else { ?>
                receipt += "<?= printLine(lang("grand_total") . ": " . $this->erp->formatMoney($inv->grand_total)); ?>" + "\n";
                <?php } ?>
                <?php if($inv->paid < $inv->grand_total) { ?>
                receipt += "<?= printLine(lang("paid_amount") . ": " . $this->erp->formatMoney($inv->paid)); ?>" + "\n";
                receipt += "<?= printLine(lang("due_amount") . ": " . $this->erp->formatMoney($inv->grand_total-$inv->paid)); ?>" + "\n\n";
                <?php } ?>
                <?php
                if($payments) {
                    foreach($payments as $payment) {
                        if ($payment->paid_by == 'cash' && $payment->pos_paid) { ?>
                receipt += "<?= printLine(lang("paid_by") . ": " . lang($payment->paid_by)); ?>" + "\n";
                receipt += "<?= printLine(lang("amount") . ": " . $this->erp->formatMoney($payment->pos_paid)); ?>" + "\n";
                receipt += "<?= printLine(lang("change") . ": " . ($payment->pos_balance > 0 ? $this->erp->formatMoney($payment->pos_balance) : 0)); ?>" + "\n";
                <?php  } if (($payment->paid_by == 'CC' || $payment->paid_by == 'ppp' || $payment->paid_by == 'stripe') && $payment->cc_no) { ?>
                receipt += "<?= printLine(lang("paid_by") . ": " . lang($payment->paid_by)); ?>" + "\n";
                receipt += "<?= printLine(lang("amount") . ": " . $this->erp->formatMoney($payment->pos_paid)); ?>" + "\n";
                receipt += "<?= printLine(lang("card_no") . ": xxxx xxxx xxxx " . substr($payment->cc_no, -4)); ?>" + "\n";
                <?php } if ($payment->paid_by == 'Cheque' && $payment->cheque_no) { ?>
                receipt += "<?= printLine(lang("paid_by") . ": " . lang($payment->paid_by)); ?>" + "\n";
                receipt += "<?= printLine(lang("amount") . ": " . $this->erp->formatMoney($payment->pos_paid)); ?>" + "\n";
                receipt += "<?= printLine(lang("cheque_no") . ": " . $payment->cheque_no); ?>" + "\n";
                <?php if ($payment->paid_by == 'other' && $payment->amount) { ?>
                receipt += "<?= printLine(lang("paid_by") . ": " . lang($payment->paid_by)); ?>" + "\n";
                receipt += "<?= printLine(lang("amount") . ": " . $this->erp->formatMoney($payment->amount)); ?>" + "\n";
                receipt += "<?= printText(lang("payment_note") . ": " . $payment->note); ?>" + "\n";
                <?php }
            }

        }
    }

    if($Settings->invoice_view == 1) {
        if(!empty($tax_summary)) {
    ?>
                receipt += "\n" + "<?= lang('tax_summary'); ?>" + "\n";
                receipt += "<?= taxLine(lang('name'),lang('code'),lang('qty'),lang('tax_excl'),lang('tax_amt')); ?>" + "\n";
                receipt += "<?php foreach ($tax_summary as $summary): ?>";
                receipt += "<?= taxLine($summary['name'],$summary['code'],$this->erp->formatQuantity($summary['items']),$this->erp->formatMoney($summary['amt']),$this->erp->formatMoney($summary['tax'])); ?>" + "\n";
                receipt += "<?php endforeach; ?>";
                receipt += "<?= printLine(lang("total_tax_amount") . ":" . $this->erp->formatMoney($inv->product_tax)); ?>" + "\n";
                <?php
                    }
                }
                ?>
                receipt += "\x1B\x61\x31";
                receipt += "\n" + "<?= $biller->invoice_footer ? printText(str_replace(array('\n', '\r'), ' ', $this->erp->decode_html($biller->invoice_footer))) : '' ?>" + "\n";
                receipt += "\x1B\x61\x30";
                <?php if(isset($pos_settings->cash_drawer_cose)) { ?>
                print(receipt, '', '<?=$pos_settings->cash_drawer_cose;?>');
                <?php } else { ?>
                print(receipt, '', '');
                <?php } ?>

            }

        </script>
    <?php } ?>
            <script type="text/javascript">			
                $(document).ready(function () {
                    $('#email').click(function () {
                        var email = prompt("<?= lang("email_address"); ?>", "<?= $customer->email; ?>");
                        if (email != null) {
                            $.ajax({
                                type: "post",
                                url: "<?= site_url('pos/email_receipt') ?>",
                                data: {<?= $this->security->get_csrf_token_name(); ?>: "<?= $this->security->get_csrf_hash(); ?>", email: email, id: <?= $inv->id; ?>},
                                dataType: "json",
                                success: function (data) {
                                    alert(data.msg);
                                },
                                error: function () {
                                    alert('<?= lang('ajax_request_failed'); ?>');
                                    return false;
                                }
                            });
                        }
                        return false;
                    });
                });
         <?php if (!$pos_settings->java_applet) { ?>
			$(window).load(function () {
				window.print();
				<?php
				if($Settings->auto_print){?>
					setTimeout('window.close()', 5000);
					document.location.href = "<?=base_url()?>pos"; 
				<?php }	?>
			});
    <?php } ?>
            </script>
</body>
</html>
<?php } ?>