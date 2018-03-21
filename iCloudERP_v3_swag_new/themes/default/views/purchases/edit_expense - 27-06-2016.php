<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-2x">&times;</i>
            </button>
            <h4 class="modal-title" id="myModalLabel"><?php echo lang('edit_expense'); ?></h4>
        </div>
        <?php $attrib = array('data-toggle' => 'validator', 'role' => 'form');
        echo form_open_multipart("purchases/edit_expense/" . $expense->id, $attrib); ?>
        <div class="modal-body">
            <p><?= lang('enter_info'); ?></p>
				
			<?php if ($Owner || $Admin) { ?>
				<div class="form-group">
					<?= lang("biller", "biller"); ?>
					<?php
					foreach ($billers as $biller) {
						$bl[$biller->id] = $biller->company != '-' ? $biller->company : $biller->name;
					}
					echo form_dropdown('biller', $bl, (isset($_POST['biller']) ? $_POST['biller'] : $pos_settings->default_biller), 'class="form-control" id="posbiller" required="required"');
					?>
				</div>
			<?php } else {
				$biller_input = array(
					'type' => 'hidden',
					'name' => 'biller',
					'id' => 'posbiller',
					'value' => $this->session->userdata('biller_id'),
				);

				echo form_input($biller_input);
			}
			?>
				
            <?php if ($Owner || $Admin) { ?>

                <div class="form-group">
                    <?= lang("date", "date"); ?>
                    <?= form_input('date', (isset($_POST['date']) ? $_POST['date'] : $this->erp->hrld($expense->date)), 'class="form-control datetime" id="date" required="required"'); ?>
                </div>
            <?php } ?>

            <div class="form-group">
                <?= lang("reference", "reference"); ?>
                <?= form_input('reference', (isset($_POST['reference']) ? $_POST['reference'] : $expense->reference), 'class="form-control tip" id="reference" required="required"'); ?>
            </div>
			
			<div class="form-group">
				<?= lang("chart_account", "chart_account"); ?>
				<?php
				$acc_section = array(""=>"");
				foreach($chart_accounts as $section){
					$acc_section[$section->accountcode] = $section->accountcode.' | '.$section->accountname;
				}
					echo form_dropdown('account_code', $acc_section, $expense->account_code ,'id="account_section" class="form-control input-tip select" data-placeholder="' . $this->lang->line("select") . ' ' . $this->lang->line("Account") . ' ' . $this->lang->line("Section") . '" required="required" style="width:100%;" ');
				?>
			</div>
			
			<div class="form-group">
				<?= lang("paid_by", "paid_by"); ?>
				<?php
				
				$acc_section = array(""=>"");
				foreach($paid_by as $section){
					$acc_section[$section->accountcode] = $section->accountcode.' | '.$section->accountname;
				}
					echo form_dropdown('paid_by', $acc_section, $expense->bank_code ,'id="paid_by" class="form-control input-tip select" data-placeholder="' . $this->lang->line("select") . ' ' . $this->lang->line("paid_by") . '" required="required" style="width:100%;" ');
				?>
			</div>
			<?php
				foreach($currency as $money){
			?>
				<div class="form-group">
					<?= lang("amount", "amount").($money->code == 'USD' ? ' (USD)' : ' (Rate: USD1 = '.$money->code.' '.number_format($money->rate).')'); ?>
					<input name="amount" type="text" id="<?=$money->code;?>" value="<?= $this->erp->formatDecimal(($expense->amount) * ($money->rate)); ?>" rate="<?=$money->rate?>" class="pa form-control kb-pad amount"/>
				</div>
			<?php
				}
			?>

            <div class="form-group">
                <?= lang("attachment", "attachment") ?>
                <input id="attachment" type="file" name="userfile" data-show-upload="false" data-show-preview="false"
                       class="form-control file">
            </div>

            <div class="form-group">
                <?= lang("note", "note"); ?>
                <?php echo form_textarea('note', (isset($_POST['note']) ? $_POST['note'] : $expense->note), 'class="form-control" id="note"'); ?>
            </div>

        </div>
        <div class="modal-footer">
            <?php echo form_submit('edit_expense', lang('edit_expense'), 'class="btn btn-primary"'); ?>
        </div>
    </div>
    <?php echo form_close(); ?>
</div>
<script type="text/javascript" src="<?= $assets ?>js/custom.js"></script>
<script type="text/javascript" charset="UTF-8">
    $.fn.datetimepicker.dates['erp'] = <?=$dp_lang?>;
</script>
<?= $modal_js ?>
<script type="text/javascript" charset="UTF-8">
    $(document).ready(function () {
		var rate = '<?=$KHM;?>';
        $.fn.datetimepicker.dates['erp'] = <?=$dp_lang?>;
		var array = <?php echo json_encode($currency) ?>;
		$.each(array, function (i, elem) {
			$(this).live('change keyup paste',function(){	
				var value = $(this).val();
				$(this).val(value);
			});
		});
		/*
		function AutoExchangeKh(){
			var amount = 0;
			var KH = 0;
			var i = 1;
			
			$('input[name="amount"]').each(function(i, item) {
				amount    +=  parseFloat($(item).val()) || 0;
			});
			KH = (amount * rate);
			
			$("#amount_kh").val(KH.toFixed(2));
		}
		function AutoExchangeEn(){
			var amount_kh = 0;
			var EN = 0;
			var i = 1;
			
			$('input[name="amount_km"]').each(function(i, item) {
				amount_kh    +=  parseFloat($(item).val()) || 0;
			});
			EN = (amount_kh / rate);
			
			$("#amount").val(EN.toFixed(2));
		}
		$('input[name="amount_km"]').live('change keyup paste',function(){	
			AutoExchangeEn();
		});
		$('input[name="amountUSD"]').live('change keyup paste',function(){	
			AutoExchangeKh();
		});
		*/
    });
</script>
