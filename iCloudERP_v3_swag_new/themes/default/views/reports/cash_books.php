<?php

$v = "";
/* if($this->input->post('name')){
  $v .= "&product=".$this->input->post('product');
} */

if ($this->input->post('account')) {
    $v .= "&account=" . $this->input->post('account');
}
if ($this->input->post('start_date')) {
    $v .= "&start_date=" . $this->input->post('start_date');
}
if ($this->input->post('end_date')) {
    $v .= "&end_date=" . $this->input->post('end_date');
}

?>
<style type="text/css">
    .topborder div { border-top: 1px solid #CCC; }
</style>

<style>.table td:nth-child(6) {
        text-align: center;
    }</style>

<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-th-large"></i><?= lang('Cash_Books_report'); ?><?php
            if ($this->input->post('start_date')) {
                echo " From " . $this->input->post('start_date') . " to " . $this->input->post('end_date');
            }
            ?></h2>

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
                <li class="dropdown"><a href="#" id="pdf" class="tip" title="<?= lang('download_pdf') ?>"><i
                            class="icon fa fa-file-pdf-o"></i></a></li>
                <li class="dropdown"><a href="#" id="xls" class="tip" title="<?= lang('download_xls') ?>"><i
                            class="icon fa fa-file-excel-o"></i></a></li>
                <li class="dropdown"><a href="#" id="image" class="tip" title="<?= lang('save_image') ?>"><i
                            class="icon fa fa-file-picture-o"></i></a></li>
				<li class="dropdown">
                            <a data-toggle="dropdown" class="dropdown-toggle" href="#"><i
                                    class="icon fa fa-building-o tip" data-placement="left"
                                    title="<?= lang("billers") ?>"></i></a>
                            <ul class="dropdown-menu pull-right" class="tasks-menus" role="menu"
                                aria-labelledby="dLabel">
                                <li><a href="<?= site_url('reports/cash_books') ?>"><i
                                            class="fa fa-building-o"></i> <?= lang('billers') ?></a></li>
                                <li class="divider"></li>
                                <?php
                                foreach ($billers as $biller) {
                                    echo '<li ' . ($biller_id && $biller_id == $biller->id ? 'class="active"' : '') . '><a href="' . site_url('reports/cash_books/0/' . $biller->id) . '"><i class="fa fa-building"></i>' . $biller->company . '</a></li>';
                                }
                                ?>
                            </ul>
                        </li>
            </ul>
        </div>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?= lang('customize_report'); ?></p>

                <div id="form">

                    <?php echo form_open("reports/cash_books"); ?>
                    <div class="row">

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label" for="user"><?= lang("account_name"); ?></label>
                                <?php
                                $accounntCode = $this->db;
                                $accOption = $accounntCode->select('*')->from('gl_charts')->where('bank', 1)->get()->result();
                                $account_[""] = " ";
                                foreach ($accOption as $a) {
                                    $account_[$a->accountcode] = $a->accountcode . " " . $a->accountname;
                                }
                                echo form_dropdown('account', $account_, (isset($_POST['account']) ? $_POST['account'] : ""), 'class="form-control" id="user" data-placeholder="' . $this->lang->line("select") . " " . $this->lang->line("account") . '"');
                                ?>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("start_date", "start_date"); ?>
                                <?php echo form_input('start_date', (isset($_POST['start_date']) ? $_POST['start_date'] : ""), 'class="form-control datetime" id="start_date"'); ?>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <?= lang("end_date", "end_date"); ?>
                                <?php echo form_input('end_date', (isset($_POST['end_date']) ? $_POST['end_date'] : ""), 'class="form-control datetime" id="end_date"'); ?>
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
                    <table id="registerTable" cellpadding="0" cellspacing="0" border="0"
                           class="table table-bordered table-hover table-striped reports-table">
                        <thead>
							<tr>
								<th><?= lang('batch'); ?></th>
								<th><?= lang('ref'); ?></th>
								<th><?= lang('Seq'); ?></th>
								<th width="250"><?= lang('description'); ?></th>
								<th><?= lang('date'); ?></th>
								<th><?= lang('type'); ?></th>
								<th><?= lang('debit_amount'); ?></th>
								<th><?= lang('credit_amount'); ?></th>
							</tr>
                        </thead>
                        <tbody>
							<?php
							if ($this->input->post('start_date') || $this->input->post('end_date') || (!$this->input->post('end_date') && !$this->input->post('end_date'))) {
								
								$accounntCode = $this->db;
								$accounntCode->select('*')->from('gl_charts')->where('bank', 1);
								if ($this->input->post('account') ) {
									$accounntCode->where('accountcode', $this->input->post('account'));
								}
								$acc = $accounntCode->get()->result();
								foreach($acc as $val){
									$gl_tranStart = $this->db->select('sum(amount) as startAmount')->from('gl_trans');
									$gl_tranStart->where(array('tran_date < '=> $this->erp->fld($this->input->post('start_date')), 'account_code'=> $val->accountcode));
									$startAmount = $gl_tranStart->get()->row();
									
									$endAccountBalance = 0;
									$getListGLTran = $this->db->select("*")->from('gl_trans')->where('account_code =', $val->accountcode);
									if ($this->input->post('start_date')) {
										$getListGLTran->where('tran_date >=', $this->erp->fld($this->input->post('start_date')) );
									}

									if ($this->input->post('end_date')) {
										$getListGLTran->where('tran_date <=', $this->erp->fld($this->input->post('end_date')) );
									}
									if (!$this->input->post('end_date') && !$this->input->post('end_date'))
									{
										$current_month = date('m');
										$getListGLTran->where('MONTH(tran_date)', $current_month);
									}
									if($biller_id != "" && $biller_id != NULL){
										$getListGLTran->where('biller_id', $biller_id);
									}
									$gltran_list = $getListGLTran->get()->result();
									if($gltran_list) {
									?>
									<tr>
										<td colspan="4">Account: <?=$val->accountcode . ' ' .$val->accountname?></td>
										<td colspan="2"><b><?= lang('begining_balance') ?>: <b></td>
										<td colspan="2"><b>
											<?=$this->erp->formatMoney($startAmount->startAmount)?>
										</b></td>
									</tr>
									<?php
									
									foreach($gltran_list as $rw)
									{
										/*
										if($rw->amount > 0) {
											$endAccountBalance = $endAccountBalance + $rw->amount; 
										} else {
											$endAccountBalance = $endAccountBalance - $rw->amount;   
										}
										*/
										$endAccountBalance += $rw->amount; 
										?>
									<tr>
										<td><?=$rw->tran_id?></td>
										<td><?=$rw->reference_no?></td>
										<td><?=$rw->tran_no?></td>
										<td><?=$rw->narrative?></td>
										<td><?=$rw->tran_date?></td>
										<td><?=$rw->tran_type?></td>
										<td><?=($rw->amount > 0 ? $this->erp->formatMoney($rw->amount) : '0.00')?></td>
										<td><?=($rw->amount < 1 ? $this->erp->formatMoney(abs($rw->amount)) : '0.00')?></td>
									</tr>
										<?php
									}
									?>
									<tr>
										<td colspan="4"> </td>
										<td colspan="2"><b><?= lang('ending_balance') ?>: </b></td>
										<td colspan="2"><b><?=$this->erp->formatMoney($endAccountBalance)?></b></td>
									</tr>
									<?php
									}else{}
								}
							}else{
								?>
								<tr>
									<td colspan="8" class="dataTables_empty"><?= lang('loading_data_from_server') ?></td>
								</tr>
								<?php
							}
							?>
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
                        </tr>
                        </tfoot>
                    </table>
                </div>

            </div>

        </div>
    </div>
</div>
<script type="text/javascript" src="<?= $assets ?>js/html2canvas.min.js"></script>
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
		/*
        $('#pdf').click(function (event) {
            event.preventDefault();
            window.location.href = "<?=site_url('reports/getRrgisterlogs/pdf/?v=1'.$v)?>";
            return false;
        });
		*/
		$('#pdf').click(function (event) {
            event.preventDefault();
            window.location.href = "<?=site_url('reports/cash_books/pdf')?>";
            return false;
        });
        $('#xls').click(function (event) {
            event.preventDefault();
            window.location.href = "<?=site_url('reports/cash_books/0/0/xls/?v=1'.$v)?>";
            return false;
        });
        $('#image').click(function (event) {
            event.preventDefault();
            html2canvas($('.box'), {
                onrendered: function (canvas) {
                    var img = canvas.toDataURL()
                    window.open(img);
                }
            });
            return false;
        });
    });
</script>