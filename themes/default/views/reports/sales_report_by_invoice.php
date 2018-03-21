<script>
	$(document).ready(function () {
        CURI = '<?= site_url('reports/getSaleReportByInvoice'); ?>';
    });
</script>
<?php
	$v = "";
	if ($this->input->post('project')) {
    $v .= "&project=" . $this->input->post('project');
	}
	if ($this->input->post('start_date')) {
    $v .= "&start_date=" . $this->input->post('start_date');
	}
	if ($this->input->post('end_date')) {
    $v .= "&end_date=" . $this->input->post('end_date');
	}
	$start_date=date('Y-m-d',strtotime($start));
	$rep_space_end=str_replace(' ','_',$end);
	$end_date=str_replace(':','-',$rep_space_end);
	
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
		/*
		$('#pdf').click(function (event) {
            event.preventDefault();
            window.location.href = "<?=site_url('reports/saleReportDetail_actions/pdf/?v=1'.$v)?>";
            return false;
        });
        $('#xls').click(function (event) {
            event.preventDefault();
            window.location.href = "<?=site_url('reports/saleReportDetail_actions/0/xls/?v=1'.$v)?>";
            return false;
        });
		*/
	});
</script>

<script>
    $(document).ready(function () {	
		var oTable = $('#DOData').dataTable({
            "aaSorting": [[0, "asc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('reports/getSaleReportByInvoice').'/'.$start_date.'/'.$end_date ?>',
            'fnServerData': function (sSource, aoData, fnCallback) {
                aoData.push({
                    "name": "<?= $this->security->get_csrf_token_name() ?>",
                    "value": "<?= $this->security->get_csrf_hash() ?>"
                });
                $.ajax({'dataType': 'json', 'type': 'POST', 'url': sSource, 'data': aoData, 'success': fnCallback});
            }        
		});
	});
</script>
<?php
	echo form_open('reports/saleReportDetail_actions', 'id="action-form"');
?>
<div class="box">
    <div class="box-header">
		<h2 class="blue"><i class="fa-fw fa fa-money"></i><?= lang('sales_report_by_invoice'); ?></h2>   
		<div class="box-icon" style="">
        <!--    <div class="form-group choose-date hidden-xs">
                <div class="controls">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
							<input type="text"
								   value="<?= ($start ? $this->erp->hrld($start) : '') . ' - ' . ($end ? $this->erp->hrld($end) : ''); ?>"
								   id="daterange" class="form-control">
						<span class="input-group-addon"><i class="fa fa-chevron-down"></i></span>
                    </div>
                </div>
            </div> -->
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
                    <?php echo form_open("reports/getSaleReportByInvoice"); ?>
                    <div class="row">                        
                            <div class="col-md-4">
                                <div class="form-group">
                                    <?= lang("project", "project"); ?>
                                    <?php
                                    $pro['0'] = lang('all');
                                    foreach ($projects as $project) {
                                        $pro[$project->id] = $project->company != '-' ? $project->company : $project->name;
                                    }
                                    echo form_dropdown('project', $pro, (isset($_POST['project']) ? $_POST['project'] : ''), 'id="slproject" data-placeholder="' . lang("select") . ' ' . lang("project") . '" required="required" class="form-control input-tip select" style="width:100%;"');
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

            </div>
        </div>
    </div>
	<div class="box-content">
        <div class="row">
		    <div class="col-lg-12" style="margin-top: -46px;">
			<?php 
				foreach($billers as $biller){ ?>
													
					<div style="width:25%;border:1px solid #a9c8d6; height: 34px;padding-top:7px;background-color:#D9EDEF;padding-left:5px;"><input type="checkbox" name="check[]" value="<?= $biller->id; ?>"/> <span style="color:blue;padding-left:10px;"><b><?= strtoupper($biller->company);?></b></span></div>   
					<table class="table table-bordered table-hover table-striped table-condensed">
						<thead>
							<tr>						
								<th style="width: 164px;"><?php echo $this->lang->line("date"); ?></th>
								<th style="width: 148px;"><?php echo $this->lang->line("invoice_no"); ?></th>                       
								<th style ="width: 251px;"><?php echo $this->lang->line("item"); ?></th>
								<th style="width: 99px;"><?php echo $this->lang->line("qty"); ?></th>
								<th><?php echo $this->lang->line("price"); ?></th>
								<th style="width: 82px;"><?php echo $this->lang->line("dis"); ?></th>
								<th><?php echo $this->lang->line("amount"); ?></th>								                     
							</tr>
						</thead>
						<tbody>
							<?php foreach ($invoices as $invoice) { ?>
								<?= $this->reports_model->getSearchInvoice($biller->id); ?>	
								
													
							<?php } ?>
						</tbody>						
					</table>
					
				  <?php				
				}	
			?>
            </div>
        </div>
    </div>
</div>
