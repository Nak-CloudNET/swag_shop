<script>
    $(document).ready(function () {
        var oTable = $('#TOData').dataTable({
            "aaSorting": [[1, "desc"]],
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "<?= lang('all') ?>"]],
            "iDisplayLength": <?= $Settings->rows_per_page ?>,
            'bProcessing': true, 'bServerSide': true,
            'sAjaxSource': '<?= site_url('transfers/getTransfers') ?>',
            'fnServerData': function (sSource, aoData, fnCallback) {
                aoData.push({
                    "name": "<?= $this->security->get_csrf_token_name() ?>",
                    "value": "<?= $this->security->get_csrf_hash() ?>"
                });
                $.ajax({'dataType': 'json', 'type': 'POST', 'url': sSource, 'data': aoData, 'success': fnCallback});
            },
            "aoColumns": [{
                "bSortable": false,
                "mRender": checkbox
            }, {"mRender": fld}, null, null, null, 
                <?php 
                    if ($Owner || $Admin) { 
                        echo '{"mRender": currencyFormat}, 
                              {"mRender": currencyFormat}, 
                              {"mRender": currencyFormat},';
                    }else{ 
                        if($GP['transfers-subtotal']){
                            echo '{"mRender": currencyFormat},';
                        }
                        echo '{"mRender": currencyFormat},';
                        if($GP['transfers-subtotal']){
                            echo '{"mRender": currencyFormat},';
                        }  
                    }
                ?> {"mRender": row_status}, {"bSortable": false}],
            'fnRowCallback': function (nRow, aData, iDisplayIndex) {
                var oSettings = oTable.fnSettings();
                nRow.id = aData[0];
                nRow.className = "transfer_link";
                return nRow;
            },    
            "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                var row_total = 0, tax = 0, gtotal = 0, a = 5;
                for (var i = 0; i < aaData.length; i++) {
                    <?php
                        if ($Owner || $Admin) {
                    ?>
                        row_total += parseFloat(aaData[aiDisplay[i]][5]);
                        tax += parseFloat(aaData[aiDisplay[i]][6]);
                        gtotal += parseFloat(aaData[aiDisplay[i]][7]);
                    <?php 
                        }else{
                            if($GP['transfers-subtotal']){
                    ?>
                            row_total += parseFloat(aaData[aiDisplay[i]][5]);
                            a = a+1;
                    <?php
                            }
                    ?>
                                tax += parseFloat(aaData[aiDisplay[i]][a]);
                    <?php
                            if($GP['transfers-subtotal']){
                    ?>
                                gtotal += parseFloat(aaData[aiDisplay[i]][7]);
                    <?php
                            }
                        }
                    ?>
                }
                var nCells = nRow.getElementsByTagName('th');
                <?php 
                    if ($Owner || $Admin) {
                    echo 'nCells[5].innerHTML = currencyFormat(formatMoney(row_total));';
                    echo 'nCells[6].innerHTML = currencyFormat(formatMoney(tax));' ;
                    echo 'nCells[7].innerHTML = currencyFormat(formatMoney(gtotal));';
                    }else{
                        $a = 5;
                        if($GP['transfers-subtotal']){
                            echo 'nCells[5].innerHTML = currencyFormat(formatMoney(row_total));';
                            $a = $a + 1;
                        }
                        echo 'nCells['.$a.'].innerHTML = currencyFormat(formatMoney(tax));';
                        if($GP['transfers-subtotal']){
                            echo 'nCells[7].innerHTML = currencyFormat(formatMoney(gtotal));';
                        }
                    }
                ?>
            }
        }).fnSetFilteringDelay().dtFilter([
            {column_number: 1, filter_default_label: "[<?=lang('date');?> (yyyy-mm-dd)]", filter_type: "text", data: []},
            {column_number: 2, filter_default_label: "[<?=lang('ref_no');?>]", filter_type: "text", data: []},
            {
                column_number: 3,
                filter_default_label: "[<?=lang("warehouse").' ('.lang('from').')';?>]",
                filter_type: "text", data: []
            },
            {
                column_number: 4,
                filter_default_label: "[<?=lang("warehouse").' ('.lang('to').')';?>]",
                filter_type: "text", data: []
            },
            <?php 
                $col = 6;
                if($GP['transfers-subtotal']){
                    $col = 8;
                }
            ?>
            {column_number: <?php echo $col; ?>, filter_default_label: "[<?=lang('status');?>]", filter_type: "text", data: []},
        ], "footer");
    });
</script>
<?php if ($Owner || $GP['bulk_actions']) {
    echo form_open('transfers/transfer_actions', 'id="action-form"');
} ?>
<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-star-o"></i><?= lang('transfers'); ?></h2>

        <div class="box-icon">
            <ul class="btn-tasks">
                <li class="dropdown">
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                        <i class="icon fa fa-tasks tip"  data-placement="left" title="<?= lang("actions") ?>"></i>
                    </a>
                    <ul class="dropdown-menu pull-right tasks-menus" role="menu" aria-labelledby="dLabel">
                        <li>
                            <a href="<?= site_url('transfers/add') ?>">
                                <i class="fa fa-plus-circle"></i> <?= lang('add_transfer') ?>
                            </a>
                        </li>
						<?php if ($Owner || $Admin) { ?>
							<!--<li>
								<a href="<?= site_url('transfers/transfer_by_csv'); ?>">
									<i class="fa fa-plus-circle"></i><span class="text"> <?= lang('add_transfer_by_csv'); ?></span>
								</a>
							</li>-->
							<li>
								<a href="#" id="excel" data-action="export_excel">
									<i class="fa fa-file-excel-o"></i> <?= lang('export_to_excel') ?>
								</a>
							</li>
							<li>
								<a href="#" id="pdf" data-action="export_pdf">
									<i class="fa fa-file-pdf-o"></i> <?= lang('export_to_pdf') ?>
								</a>
							</li>
                        <?php }else{ ?>
							<?php if($GP['transfers-import']) { ?>
								<!--<li>
									<a href="<?= site_url('transfers/transfer_by_csv'); ?>">
										<i class="fa fa-plus-circle"></i><span class="text"> <?= lang('add_transfer_by_csv'); ?></span>
									</a>
								</li>-->
							<?php }?>
							<?php if($GP['transfers-export']) { ?>
								<li>
									<a href="#" id="excel" data-action="export_excel">
										<i class="fa fa-file-excel-o"></i> <?= lang('export_to_excel') ?>
									</a>
								</li>
								<li>
									<a href="#" id="pdf" data-action="export_pdf">
										<i class="fa fa-file-pdf-o"></i> <?= lang('export_to_pdf') ?>
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
                        <li>
                            <a href="#" class="bpo" title="<?= $this->lang->line("delete_transfers") ?>"
                             data-content="<p><?= lang('r_u_sure') ?></p><button type='button' class='btn btn-danger' id='delete' data-action='delete'><?= lang('i_m_sure') ?></a> <button class='btn bpo-close'><?= lang('no') ?></button>"
                             data-html="true" data-placement="left">
                             <i class="fa fa-trash-o"></i> <?= lang('delete_transfers') ?>
                         </a>
                     </li>
                 </ul>
             </li>
            </ul>
        </div>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?= lang('list_results'); ?></p>

                <div class="table-responsive">
                    <table id="TOData" cellpadding="0" cellspacing="0" border="0"
                           class="table table-bordered table-condensed table-hover table-striped">
                        <thead>
                        <tr class="active">
                            <th style="min-width:30px; width: 30px; text-align: center;">
                                <input class="checkbox checkft" type="checkbox" name="check"/>
                            </th>
                            <th><?= lang("date"); ?></th>
                            <th><?= lang("ref_no"); ?></th>
                            <th><?= lang("warehouse") . ' (' . lang('from') . ')'; ?></th>
                            <th><?= lang("warehouse") . ' (' . lang('to') . ')'; ?></th>
                            <?php 
                                if ($Owner || $Admin) { 
                                    echo '<th>'.lang("total").'</th>';
                                    echo '<th>'.lang("product_tax").'</th>';
                                    echo '<th>'.lang("grand_total").'</th>';
                                }else{ 
                                    if($GP['transfers-subtotal']){
                                        echo '<th>'.lang("total").'</th>';
                                    }
                                    echo '<th>'.lang("product_tax").'</th>';
                                    if($GP['transfers-subtotal']){
                                        echo '<th>'.lang("grand_total").'</th>';
                                    }  
                                }
                            ?>
                            <th><?= lang("status"); ?></th>
                            <th style="width:100px;"><?= lang("actions"); ?></th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td colspan="10" class="dataTables_empty"><?= lang('loading_data_from_server'); ?></td>
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
                            <?php 
                                if ($Owner || $Admin) { 
                                    echo '<th></th><th></th><th></th>';
                                }else{ 
                                    if($GP['transfers-subtotal']){
                                        echo '<th></th>';
                                    }
                                    echo '<th></th>';
                                    if($GP['transfers-subtotal']){
                                        echo '<th></th>';
                                    }  
                                }
                            ?>
                            <th></th>
                            <th style="width:100px; text-align: center;"><?= lang("actions"); ?></th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<?php if ($Owner || $GP['bulk_actions']) { ?>
    <div style="display: none;">
        <input type="hidden" name="form_action" value="" id="form_action"/>
        <?= form_submit('performAction', 'performAction', 'id="action-form-submit"') ?>
    </div>
    <?= form_close() ?>
<?php } ?>