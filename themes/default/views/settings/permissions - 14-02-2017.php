<?php //$this->erp->print_arrays($p); ?>

<style>
    .table td:first-child {
        font-weight: bold;
    }

    label {
        margin-right: 10px;
    }
</style>
<div class="box">
    <div class="box-header">
        <h2 class="blue"><i class="fa-fw fa fa-folder-open"></i><?= lang('group_permissions'); ?></h2>
    </div>
    <div class="box-content">
        <div class="row">
            <div class="col-lg-12">

                <p class="introtext"><?= lang("set_permissions"); ?></p>

                <?php if (!empty($p)) {
                    if ($p->group_id != 1) {

                        echo form_open("system_settings/permissions/" . $id); ?>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-striped">

                                <thead>
									<tr>
										<th colspan="7"
											class="text-center"><?php echo $group->description . ' ( ' . $group->name . ' ) ' . $this->lang->line("group_permissions"); ?></th>
									</tr>
									<tr>
										<th rowspan="2" class="text-center"><?= lang("module_name"); ?>
										</th>
										<th colspan="6" class="text-center"><?= lang("permissions"); ?></th>
									</tr>
									<tr>
										<th class="text-center"><?= lang("view"); ?></th>
										<th class="text-center"><?= lang("add"); ?></th>
										<th class="text-center"><?= lang("edit"); ?></th>
										<th class="text-center"><?= lang("delete"); ?></th>
										<th class="text-center"><?= lang("import"); ?></th>
										<th class="text-center"><?= lang("export"); ?></th>
										<th class="text-center"><?= lang("misc"); ?></th>
									</tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td><?= lang("products"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-index" <?php echo $p->{'products-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-add" <?php echo $p->{'products-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-edit" <?php echo $p->{'products-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-delete" <?php echo $p->{'products-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-import" <?php echo $p->{'products-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="products-export" <?php echo $p->{'products-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <input type="checkbox" value="1" id="products-cost" class="checkbox"
                                               name="products-cost" <?php echo $p->{'products-cost'} ? "checked" : ''; ?>><label
                                            for="products-cost" class="padding05"><?= lang('product_cost') ?></label>
                                        <input type="checkbox" value="1" id="products-price" class="checkbox"
                                               name="products-price" <?php echo $p->{'products-price'} ? "checked" : ''; ?>><label
                                            for="products-price" class="padding05"><?= lang('product_price') ?></label>
                                        <input type="checkbox" value="1" id="products-adjustments" class="checkbox"
                                            name="products-adjustments" <?php echo $p->{'products-adjustments'} ? "checked" : ''; ?>><label
                                            for="products-adjustments" class="padding05"><?= lang('quantity_adjustments') ?></label>
                                    </td>
                                </tr>

                                <tr>
                                    <td><?= lang("sales"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-index" <?php echo $p->{'sales-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-add" <?php echo $p->{'sales-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-edit" <?php echo $p->{'sales-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-delete" <?php echo $p->{'sales-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-import" <?php echo $p->{'sales-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-export" <?php echo $p->{'sales-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <input type="checkbox" value="1" id="sales-email" class="checkbox"
                                               name="sales-email" <?php echo $p->{'sales-email'} ? "checked" : ''; ?>><label
                                            for="sales-email" class="padding05"><?= lang('email') ?></label>
                                        <!--<input type="checkbox" value="1" id="sales-pdf" class="checkbox"
                                               name="sales-pdf" <?php echo $p->{'sales-pdf'} ? "checked" : ''; ?>><label
                                            for="sales-pdf" class="padding05"><?= lang('pdf') ?></label>-->
                                        <?php if (POS) { ?>
                                            <input type="checkbox" value="1" id="pos-index" class="checkbox"
                                                   name="pos-index" <?php echo $p->{'pos-index'} ? "checked" : ''; ?>>
                                            <label for="pos-index" class="padding05"><?= lang('pos') ?></label>
                                        <?php } ?>
                                        <input type="checkbox" value="1" id="sales-payments" class="checkbox"
                                               name="sales-payments" <?php echo $p->{'sales-payments'} ? "checked" : ''; ?>><label
                                            for="sales-payments" class="padding05"><?= lang('payments') ?></label>
                                        <input type="checkbox" value="1" id="sales-return_sales" class="checkbox"
                                               name="sales-return_sales" <?php echo $p->{'sales-return_sales'} ? "checked" : ''; ?>><label
                                            for="sales-return_sales"
                                            class="padding05"><?= lang('return') ?></label>
										<input type="checkbox" value="1" id="sales-loan" class="checkbox"
                                               name="sales-loan" <?php echo $p->{'sales-loan'} ? "checked" : ''; ?>><label
                                            for="sales-loan"
                                            class="padding05"><?= lang('loans') ?></label>
										<input type="checkbox" value="1" id="sales-discount" class="checkbox"
                                               name="sales-discount" <?php echo $p->{'sales-discount'} ? "checked" : ''; ?>><label
                                            for="sales-discount"
                                            class="padding05"><?= lang('discount') ?></label>
										<input type="checkbox" value="1" id="sales-price" class="checkbox"
                                               name="sales-price" <?php echo $p->{'sales-price'} ? "checked" : ''; ?>><label
                                            for="sales-price"
                                            class="padding05"><?= lang('price') ?></label>
                                    </td>
                                </tr>

                                <tr>
                                    <td><?= lang("deliveries"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-deliveries" <?php echo $p->{'sales-deliveries'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-add_delivery" <?php echo $p->{'sales-add_delivery'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-edit_delivery" <?php echo $p->{'sales-edit_delivery'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-delete_delivery" <?php echo $p->{'sales-delete_delivery'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-import_delivery" <?php echo $p->{'sales-import_delivery'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-export_delivery" <?php echo $p->{'sales-export_delivery'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <!--<input type="checkbox" value="1" id="sales-email" class="checkbox" name="sales-email_delivery" <?php echo $p->{'sales-email_delivery'} ? "checked" : ''; ?>><label for="sales-email_delivery" class="padding05"><?= lang('email') ?></label>
                                        <input type="checkbox" value="1" id="sales-pdf" class="checkbox"
                                               name="sales-pdf_delivery" <?php echo $p->{'sales-pdf_delivery'} ? "checked" : ''; ?>><label
                                            for="sales-pdf_delivery" class="padding05"><?= lang('pdf') ?></label>
											-->
                                    </td>
                                </tr>
                                <tr>
                                    <td><?= lang("gift_cards"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-gift_cards" <?php echo $p->{'sales-gift_cards'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-add_gift_card" <?php echo $p->{'sales-add_gift_card'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-edit_gift_card" <?php echo $p->{'sales-edit_gift_card'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-delete_gift_card" <?php echo $p->{'sales-delete_gift_card'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-import_gift_card" <?php echo $p->{'sales-import_gift_card'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sales-export_gift_card" <?php echo $p->{'sales-export_gift_card'} ? "checked" : ''; ?>>
                                    </td>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td><?= lang("quotes"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-index" <?php echo $p->{'quotes-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-add" <?php echo $p->{'quotes-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-edit" <?php echo $p->{'quotes-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-delete" <?php echo $p->{'quotes-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-import" <?php echo $p->{'quotes-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="quotes-export" <?php echo $p->{'quotes-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <input type="checkbox" value="1" id="quotes-email" class="checkbox"
                                               name="quotes-email" <?php echo $p->{'quotes-email'} ? "checked" : ''; ?>><label
                                            for="quotes-email" class="padding05"><?= lang('email') ?></label>
                                        <!--
										<input type="checkbox" value="1" id="quotes-pdf" class="checkbox"
                                               name="quotes-pdf" <?php echo $p->{'quotes-pdf'} ? "checked" : ''; ?>><label
                                            for="quotes-pdf" class="padding05"><?= lang('pdf') ?></label>-->
                                    </td>
                                </tr>

                                <tr>
                                    <td><?= lang("purchases"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-index" <?php echo $p->{'purchases-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-add" <?php echo $p->{'purchases-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-edit" <?php echo $p->{'purchases-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-delete" <?php echo $p->{'purchases-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-import" <?php echo $p->{'purchases-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="purchases-export" <?php echo $p->{'purchases-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <input type="checkbox" value="1" id="purchases-email" class="checkbox"
                                               name="purchases-email" <?php echo $p->{'purchases-email'} ? "checked" : ''; ?>><label
                                            for="purchases-email" class="padding05"><?= lang('email') ?></label>
                                        <!--<input type="checkbox" value="1" id="purchases-pdf" class="checkbox"
                                               name="purchases-pdf" <?php echo $p->{'purchases-pdf'} ? "checked" : ''; ?>><label
                                            for="purchases-pdf" class="padding05"><?= lang('pdf') ?></label>-->
                                        <input type="checkbox" value="1" id="purchases-payments" class="checkbox"
                                               name="purchases-payments" <?php echo $p->{'purchases-payments'} ? "checked" : ''; ?>><label
                                            for="purchases-payments" class="padding05"><?= lang('payments') ?></label>
                                        <input type="checkbox" value="1" id="purchases-expenses" class="checkbox"
                                               name="purchases-expenses" <?php echo $p->{'purchases-expenses'} ? "checked" : ''; ?>><label
                                            for="purchases-expenses" class="padding05"><?= lang('expenses') ?></label>
                                    </td>
                                </tr>
								<!-- Permition ACC-->
								<tr>
                                    <td><?= lang("accounts"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-index" <?php echo $p->{'accounts-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-add" <?php echo $p->{'accounts-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-edit" <?php echo $p->{'accounts-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-delete" <?php echo $p->{'accounts-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-import" <?php echo $p->{'accounts-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="accounts-export" <?php echo $p->{'accounts-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td><?= lang("transfers"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-index" <?php echo $p->{'transfers-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-add" <?php echo $p->{'transfers-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-edit" <?php echo $p->{'transfers-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-delete" <?php echo $p->{'transfers-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-import" <?php echo $p->{'transfers-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="transfers-export" <?php echo $p->{'transfers-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                        <input type="checkbox" value="1" id="transfers-email" class="checkbox"
                                               name="transfers-email" <?php echo $p->{'transfers-email'} ? "checked" : ''; ?>><label
                                            for="transfers-email" class="padding05"><?= lang('email') ?></label>
                                        <!--<input type="checkbox" value="1" id="transfers-pdf" class="checkbox"
                                               name="transfers-pdf" <?php echo $p->{'transfers-pdf'} ? "checked" : ''; ?>><label
                                            for="transfers-pdf" class="padding05"><?= lang('pdf') ?></label>-->
                                    </td>
                                </tr>

                                <tr>
                                    <td><?= lang("customers"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-index" <?php echo $p->{'customers-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-add" <?php echo $p->{'customers-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-edit" <?php echo $p->{'customers-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-delete" <?php echo $p->{'customers-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-import" <?php echo $p->{'customers-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="customers-export" <?php echo $p->{'customers-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td>
                                    </td>
                                </tr>

                                <tr>
                                    <td><?= lang("suppliers"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-index" <?php echo $p->{'suppliers-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-add" <?php echo $p->{'suppliers-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-edit" <?php echo $p->{'suppliers-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-delete" <?php echo $p->{'suppliers-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-import" <?php echo $p->{'suppliers-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="suppliers-export" <?php echo $p->{'suppliers-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td></td>
                                </tr>
								
								<tr>
                                    <td><?= lang("room || table calendar"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-index" <?php echo $p->{'room-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-add" <?php echo $p->{'room-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-edit" <?php echo $p->{'room-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-delete" <?php echo $p->{'room-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-import" <?php echo $p->{'room-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="room-export" <?php echo $p->{'room-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td></td>
                                </tr>
								
								<tr>
                                    <td><?= lang("list sale room || table"); ?></td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-index" <?php echo $p->{'sale-room-index'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-add" <?php echo $p->{'sale-room-add'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-edit" <?php echo $p->{'sale-room-edit'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-delete" <?php echo $p->{'sale-room-delete'} ? "checked" : ''; ?>>
                                    </td>
									<td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-import" <?php echo $p->{'sale-room-import'} ? "checked" : ''; ?>>
                                    </td>
                                    <td class="text-center">
                                        <input type="checkbox" value="1" class="checkbox"
                                               name="sale-room-export" <?php echo $p->{'sale-room-export'} ? "checked" : ''; ?>>
                                    </td>
                                    <td></td>
                                </tr>
								
								

                                </tbody>
                            </table>
                        </div>
                        <div class="table-responsive">
                            <table cellpadding="0" cellspacing="0" border="0"
                                   class="table table-bordered table-hover table-striped" style="margin-bottom: 5px;">

                                <thead>
                                <tr>
                                    <th><?= lang("reports"); ?>
                                    </th>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="checkbox" value="1" class="checkbox" id="products"
                                               name="reports-products" <?php echo $p->{'reports-products'} ? "checked" : ''; ?>><label
                                            for="products" class="padding05"><?= lang('products') ?></label>
                                        <input type="checkbox" value="1" class="checkbox" id="sales"
                                               name="reports-sales" <?php echo $p->{'reports-sales'} ? "checked" : ''; ?>><label
                                            for="sales" class="padding05"><?= lang('sales') ?></label>
                                        <input type="checkbox" value="1" class="checkbox" id="purchases"
                                               name="reports-purchases" <?php echo $p->{'reports-purchases'} ? "checked" : ''; ?>><label
                                            for="purchases" class="padding05"><?= lang('purchases') ?></label>
										<input type="checkbox" value="1" class="checkbox" id="account"
											name="reports-account" <?php echo $p->{'reports-account'}? "checked" : '';?>>
											<label for="account" class="padding05"><?= lang('accounts') ?></label>
                                    </td>
                                </tr>
                                </thead>
                            </table>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary"><?=lang('update')?></button>
                        </div>
                        <?php echo form_close();
                    } else {
                        echo $this->lang->line("group_x_allowed");
                    }
                } else {
                    echo $this->lang->line("group_x_allowed");
                } ?>


            </div>
        </div>
    </div>
</div>