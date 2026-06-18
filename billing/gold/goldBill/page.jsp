<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Gold Buyer Entry</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/assets/common/head.jsp" %>
    <style>
        /* ─── Gold Rate Banner ─── */
        .gold-rate-banner {
            background: linear-gradient(135deg, #1a2540 0%, #c9a227 100%);
            border-radius: 0.75rem;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 4px 18px rgba(201,162,39,0.25);
            flex-wrap: wrap;
        }
        .gold-rate-banner .gr-label {
            color: #fff;
            font-weight: 700;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            white-space: nowrap;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .gold-rate-banner .gr-label i {
            font-size: 1.2rem;
            color: #ffe066;
        }
        .gold-rate-input-wrap {
            display: flex;
            align-items: center;
            background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.4);
            border-radius: 0.5rem;
            padding: 4px 12px;
            gap: 6px;
            flex: 1;
            min-width: 140px;
            max-width: 220px;
        }
        .gold-rate-input-wrap .gr-symbol {
            color: #ffe066;
            font-weight: 800;
            font-size: 1rem;
        }
        .gold-rate-input-wrap input {
            background: transparent;
            border: none;
            outline: none;
            color: #fff;
            font-size: 1.4rem;
            font-weight: 800;
            width: 100%;
            letter-spacing: 1px;
        }
        .gold-rate-input-wrap input::placeholder { color: rgba(255,255,255,0.55); }
        .gr-unit {
            color: rgba(255,255,255,0.8);
            font-size: 0.78rem;
            white-space: nowrap;
        }

        /* ─── Section Cards ─── */
        .gb-section {
            background: #fff;
            border-radius: 0.75rem;
            box-shadow: 0 2px 12px rgba(26,37,64,0.08);
            padding: 20px;
            margin-bottom: 18px;
        }
        .gb-section-title {
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: #1a2540;
            border-left: 3px solid #c9a227;
            padding-left: 10px;
            margin-bottom: 16px;
        }

        /* ─── Proof Boxes ─── */
        .proof-box {
            border: 2px dashed #c9a22760;
            border-radius: 0.6rem;
            padding: 14px 16px;
            background: #fffdf4;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .proof-box label {
            font-size: 0.75rem;
            font-weight: 600;
            color: #1a2540;
            margin-bottom: 2px;
        }

        /* ─── Billing Table ─── */
        .billing-table-wrap {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border-radius: 0.6rem;
        }
        .billing-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            min-width: 700px;
        }
        .billing-table thead tr {
            background: linear-gradient(135deg, #1a2540 0%, #1e2d55 100%);
        }
        .billing-table thead th {
            color: #fff;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            padding: 10px 10px;
            border: none;
            white-space: nowrap;
        }
        .billing-table thead th:first-child { border-radius: 0.6rem 0 0 0; }
        .billing-table thead th:last-child  { border-radius: 0 0.6rem 0 0; }
        .billing-table tbody tr { transition: background 0.15s; }
        .billing-table tbody tr:nth-child(even) { background: #f9f7f0; }
        .billing-table tbody tr:hover { background: #fef9ec; }
        .billing-table td {
            padding: 6px 6px;
            vertical-align: middle;
            border-bottom: 1px solid #f0ede0;
        }
        .billing-table .row-input {
            width: 100%;
            border: 1.5px solid #ddd;
            border-radius: 0.4rem;
            padding: 5px 8px;
            font-size: 0.8rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fff;
        }
        .billing-table .row-input:focus {
            border-color: #c9a227;
            box-shadow: 0 0 0 2px rgba(201,162,39,0.18);
        }
        .billing-table .row-input.is-invalid {
            border-color: #f87171;
            box-shadow: 0 0 0 2px rgba(248,113,113,0.15);
        }
        .gross-amount-cell {
            font-weight: 700;
            color: #1a2540;
            text-align: right;
            min-width: 90px;
            padding-right: 12px;
            font-size: 0.85rem;
        }
        .btn-del-row {
            background: none;
            border: 1.5px solid #f87171;
            color: #f87171;
            border-radius: 0.4rem;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
            font-size: 0.8rem;
        }
        .btn-del-row:hover { background: #f87171; color: #fff; }

        /* ─── Add Row Button ─── */
        .btn-add-row {
            background: linear-gradient(135deg, #1a2540, #1e2d55);
            color: #fff;
            border: none;
            border-radius: 0.5rem;
            padding: 8px 18px;
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: opacity 0.2s;
        }
        .btn-add-row:hover { opacity: 0.88; }

        /* ─── Totals Bar ─── */
        .totals-bar {
            background: linear-gradient(135deg, #1a2540, #1e2d55);
            border-radius: 0.6rem;
            padding: 14px 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: center;
            justify-content: flex-end;
            margin-top: 14px;
        }
        .totals-bar .tot-item {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }
        .totals-bar .tot-label {
            color: rgba(255,255,255,0.65);
            font-size: 0.68rem;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        .totals-bar .tot-value {
            color: #ffe066;
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: 0.5px;
        }

        /* ─── Submit Bar ─── */
        .submit-bar {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            flex-wrap: wrap;
            padding: 0 0 10px;
        }
        .btn-gb-save {
            background: linear-gradient(135deg, #c9a227, #dbb82e);
            color: #1a2540;
            border: none;
            border-radius: 0.5rem;
            padding: 10px 30px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 14px rgba(201,162,39,0.3);
            transition: opacity 0.2s;
        }
        .btn-gb-save:hover { opacity: 0.9; }
        .btn-gb-reset {
            background: #f0f0f0;
            color: #555;
            border: 1.5px solid #ddd;
            border-radius: 0.5rem;
            padding: 10px 22px;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background 0.15s;
        }
        .btn-gb-reset:hover { background: #e0e0e0; }

        /* ─── Mobile tweaks ─── */
        @media (max-width: 768px) {
            .gold-rate-banner { gap: 10px; }
            .gold-rate-input-wrap { max-width: 100%; }
            .gb-section { padding: 14px 12px; }
            .totals-bar { justify-content: flex-start; }
            .submit-bar { justify-content: stretch; }
            .btn-gb-save, .btn-gb-reset { flex: 1; justify-content: center; }
        }

        /* ─── Autocomplete dropdown override ─── */
        .ui-autocomplete {
            font-size: 0.8rem;
            border-radius: 0.4rem;
            border: 1.5px solid #c9a22760;
            box-shadow: 0 4px 14px rgba(0,0,0,0.12);
            z-index: 9999;
        }
        .ui-menu-item-wrapper { padding: 7px 12px; }
        .ui-state-active, .ui-widget-content .ui-state-active {
            background: #c9a227 !important;
            color: #fff !important;
            border-color: #c9a227 !important;
        }
    </style>
</head>
<body>

<%@ include file="/assets/navbar/navbar.jsp" %>

<%
    request.setAttribute("pageTitle",    "Gold Buyer Entry");
    request.setAttribute("pageSubtitle", "Record gold purchase from customer");
    request.setAttribute("pageIcon",     "fa-solid fa-coins");
%>
<jsp:include page="/assets/common/pageHeader.jsp" />

<div class="container-fluid mt-3 mst-page pb-4" style="max-width:1100px;">

    <!-- ══════════════ GOLD RATE BANNER ══════════════ -->
    <div class="gold-rate-banner mb-3">
        <div class="gr-label">
            <i class="fas fa-coins"></i>
            Today's Gold Rate
        </div>
        <div class="gold-rate-input-wrap">
            <span class="gr-symbol">₹</span>
            <input type="number" id="goldRateInput" placeholder="0.00" min="0" step="0.01" autocomplete="off">
        </div>
        <span class="gr-unit">/ gram &nbsp;|&nbsp; Updated live</span>
    </div>

    <!-- ══════════════ CUSTOMER & BILL INFO ══════════════ -->
    <div class="gb-section">
        <div class="gb-section-title"><i class="fas fa-user-circle me-2"></i>Customer Details</div>
        <div class="row g-3">

            <!-- Customer Name -->
            <div class="col-md-4 col-sm-6 input-outline">
                <input type="text" id="custName" class="form-control" placeholder=" " autocomplete="off">
                <label>Customer Name</label>
            </div>

            <!-- Phone Number -->
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="text" id="custPhone" class="form-control" placeholder=" " autocomplete="off" maxlength="15">
                <label>Phone Number</label>
            </div>

            <!-- Bill Date -->
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="date" id="billDate" class="form-control" placeholder=" ">
                <label>Bill Date</label>
            </div>

            <!-- Bill Time -->
            <div class="col-md-2 col-sm-6 input-outline">
                <input type="time" id="billTime" class="form-control" placeholder=" ">
                <label>Bill Time</label>
            </div>

        </div>
    </div>

    <!-- ══════════════ ID & ADDRESS PROOF ══════════════ -->
    <div class="gb-section">
        <div class="gb-section-title"><i class="fas fa-id-card me-2"></i>Proof Details</div>
        <div class="row g-3">

            <!-- ID Proof -->
            <div class="col-md-6">
                <div class="proof-box">
                    <label><i class="fas fa-fingerprint me-1" style="color:#c9a227;"></i>ID Proof</label>
                    <div class="row g-2">
                        <div class="col-5 input-outline">
                            <select id="idProofType" class="form-select" >
                                <option value="" disabled selected></option>
                                <option>Aadhaar Card</option>
                                <option>PAN Card</option>
                                <option>Voter ID</option>
                                <option>Passport</option>
                                <option>Driving Licence</option>
                                <option>Other</option>
                            </select>
                            <label>Proof Type</label>
                        </div>
                        <div class="col-7 input-outline">
                            <input type="text" id="idProofNo" class="form-control" placeholder=" ">
                            <label>Proof Number</label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Address Proof -->
            <div class="col-md-6">
                <div class="proof-box">
                    <label><i class="fas fa-map-marker-alt me-1" style="color:#c9a227;"></i>Address Proof</label>
                    <div class="row g-2">
                        <div class="col-5 input-outline">
                            <select id="addrProofType" class="form-select">
                                <option value="" disabled selected></option>
                                <option>Aadhaar Card</option>
                                <option>Voter ID</option>
                                <option>Passport</option>
                                <option>Utility Bill</option>
                                <option>Bank Passbook</option>
                                <option>Other</option>
                            </select>
                            <label>Proof Type</label>
                        </div>
                        <div class="col-7 input-outline">
                            <input type="text" id="addrProofNo" class="form-control" placeholder=" ">
                            <label>Proof Number / Details</label>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- ══════════════ BILLING PARTICULARS ══════════════ -->
    <div class="gb-section">
        <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
            <div class="gb-section-title mb-0"><i class="fas fa-layer-group me-2"></i>Billing Particulars</div>
            <button class="btn-add-row" id="btnAddRow" type="button">
                <i class="fas fa-plus"></i> Add Row
            </button>
        </div>

        <div class="billing-table-wrap">
            <table class="billing-table" id="billingTable">
                <thead>
                    <tr>
                        <th style="width:36px;">#</th>
                        <th style="min-width:140px;">Ornament Type</th>
                        <th style="min-width:100px;">Gross Wt (g)</th>
                        <th style="min-width:100px;">Stone/Wax (g)</th>
                        <th style="min-width:100px;">Net Wt (g)</th>
                        <th style="min-width:90px;">Purity</th>
                        <th style="min-width:110px; text-align:right;">Gross Amount</th>
                        <th style="width:40px;"></th>
                    </tr>
                </thead>
                <tbody id="billingBody">
                    <!-- rows injected by JS -->
                </tbody>
            </table>
        </div>

        <!-- Totals Bar -->
        <div class="totals-bar">
            <div class="tot-item">
                <span class="tot-label">Total Net Wt (g)</span>
                <span class="tot-value" id="totalNetWt">0.000</span>
            </div>
            <div class="tot-item" style="margin-left:30px;">
                <span class="tot-label">Total Gross Amount</span>
                <span class="tot-value" id="totalGrossAmt">₹ 0.00</span>
            </div>
        </div>
    </div>

    <!-- ══════════════ ACTION BAR ══════════════ -->
    <div class="submit-bar">
        <button class="btn-gb-reset" type="button" id="btnReset">
            <i class="fas fa-undo"></i> Reset
        </button>
        <button class="btn-gb-save" type="button" id="btnSave">
            <i class="fas fa-save"></i> Save Bill
        </button>
    </div>

</div><!-- /container -->

<script>
(function () {
    "use strict";

    /* ── Set default date & time ── */
    (function setDefaults() {
        var now = new Date();
        var yyyy = now.getFullYear();
        var mm   = String(now.getMonth() + 1).padStart(2, '0');
        var dd   = String(now.getDate()).padStart(2, '0');
        document.getElementById('billDate').value = yyyy + '-' + mm + '-' + dd;

        var hh = String(now.getHours()).padStart(2, '0');
        var mi = String(now.getMinutes()).padStart(2, '0');
        document.getElementById('billTime').value = hh + ':' + mi;
    })();

    /* ── Row management ── */
    var rowCount = 0;

    function createRow() {
        rowCount++;
        var idx = rowCount;
        var tr = document.createElement('tr');
        tr.setAttribute('data-row', idx);
        tr.innerHTML =
            '<td style="text-align:center;color:#888;font-size:0.75rem;" class="row-num">' + idx + '</td>' +
            '<td><input type="text"   class="row-input" data-col="ornament"  placeholder="e.g. Necklace" autocomplete="off"></td>' +
            '<td><input type="number" class="row-input" data-col="gross_wt"  placeholder="0.000" min="0" step="0.001" inputmode="decimal"></td>' +
            '<td><input type="number" class="row-input" data-col="stone_wax" placeholder="0.000" min="0" step="0.001" inputmode="decimal"></td>' +
            '<td><input type="number" class="row-input" data-col="net_wt"    placeholder="0.000" min="0" step="0.001" inputmode="decimal" readonly style="background:#f9f7f0;"></td>' +
            '<td><input type="text"   class="row-input" data-col="purity"    placeholder="e.g. 22K" autocomplete="off"></td>' +
            '<td class="gross-amount-cell" data-col="gross_amount">0.00</td>' +
            '<td style="text-align:center;"><button class="btn-del-row" title="Delete row"><i class="fas fa-trash-alt"></i></button></td>';

        /* Auto-calc net weight */
        var grossWtInput  = tr.querySelector('[data-col="gross_wt"]');
        var stoneWaxInput = tr.querySelector('[data-col="stone_wax"]');
        var netWtInput    = tr.querySelector('[data-col="net_wt"]');
        var grossAmtCell  = tr.querySelector('[data-col="gross_amount"]');

        function calcNet() {
            var g = parseFloat(grossWtInput.value)  || 0;
            var s = parseFloat(stoneWaxInput.value) || 0;
            var net = Math.max(0, g - s);
            netWtInput.value = net.toFixed(3);
            calcGrossAmt();
        }

        function calcGrossAmt() {
            var net  = parseFloat(netWtInput.value) || 0;
            var rate = parseFloat(document.getElementById('goldRateInput').value) || 0;
            var amt  = net * rate;
            grossAmtCell.textContent = amt.toFixed(2);
            updateTotals();
        }

        grossWtInput.addEventListener('input', calcNet);
        stoneWaxInput.addEventListener('input', calcNet);

        /* Delete row */
        tr.querySelector('.btn-del-row').addEventListener('click', function () {
            if (document.querySelectorAll('#billingBody tr').length === 1) return; /* keep ≥1 row */
            tr.remove();
            reNumberRows();
            updateTotals();
        });

        /* Clear validation highlight on input */
        tr.querySelectorAll('.row-input').forEach(function (inp) {
            inp.addEventListener('input', function () { inp.classList.remove('is-invalid'); });
        });

        return tr;
    }

    function reNumberRows() {
        var rows = document.querySelectorAll('#billingBody tr');
        rows.forEach(function (r, i) {
            var numCell = r.querySelector('.row-num');
            if (numCell) numCell.textContent = i + 1;
            r.setAttribute('data-row', i + 1);
        });
        rowCount = rows.length;
    }

    function updateTotals() {
        var rows = document.querySelectorAll('#billingBody tr');
        var totalNet = 0, totalAmt = 0;
        rows.forEach(function (r) {
            totalNet += parseFloat(r.querySelector('[data-col="net_wt"]').value) || 0;
            totalAmt += parseFloat(r.querySelector('[data-col="gross_amount"]').textContent) || 0;
        });
        document.getElementById('totalNetWt').textContent  = totalNet.toFixed(3);
        document.getElementById('totalGrossAmt').textContent = '₹ ' + totalAmt.toFixed(2);
    }

    /* Gold rate change → recalc all rows */
    document.getElementById('goldRateInput').addEventListener('input', function () {
        document.querySelectorAll('#billingBody tr').forEach(function (r) {
            var net  = parseFloat(r.querySelector('[data-col="net_wt"]').value) || 0;
            var rate = parseFloat(document.getElementById('goldRateInput').value) || 0;
            r.querySelector('[data-col="gross_amount"]').textContent = (net * rate).toFixed(2);
        });
        updateTotals();
    });

    /* Add Row button */
    document.getElementById('btnAddRow').addEventListener('click', function () {
        var tbody = document.getElementById('billingBody');
        var row = createRow();
        tbody.appendChild(row);
        row.querySelector('[data-col="ornament"]').focus();
    });

    /* Initial first row */
    document.getElementById('billingBody').appendChild(createRow());

    /* ── Validation ── */
    function validateForm() {
        var valid = true;

        /* Customer name */
        var cn = document.getElementById('custName');
        if (!cn.value.trim()) { cn.classList.add('is-invalid'); valid = false; }
        else cn.classList.remove('is-invalid');

        /* Billing rows */
        var rows = document.querySelectorAll('#billingBody tr');
        rows.forEach(function (r) {
            var ornament  = r.querySelector('[data-col="ornament"]');
            var grossWt   = r.querySelector('[data-col="gross_wt"]');
            var grossAmt  = parseFloat(r.querySelector('[data-col="gross_amount"]').textContent) || 0;

            if (!ornament.value.trim()) { ornament.classList.add('is-invalid'); valid = false; }
            if (!(parseFloat(grossWt.value) >= 0)) { grossWt.classList.add('is-invalid'); valid = false; }
            if (grossAmt <= 0) {
                r.querySelector('[data-col="gross_amount"]').style.color = '#f87171';
                valid = false;
            } else {
                r.querySelector('[data-col="gross_amount"]').style.color = '';
            }
        });

        if (!valid) {
            Swal.fire({
                icon: 'warning',
                title: 'Incomplete Entry',
                text: 'Please fill all required fields. Gross Amount must be greater than 0.',
                confirmButtonColor: '#c9a227'
            });
        }
        return valid;
    }

    /* ── Save ── */
    document.getElementById('btnSave').addEventListener('click', function () {
        if (!validateForm()) return;
        /* TODO: submit data via AJAX/form */
        Swal.fire({
            icon: 'info',
            title: 'Ready to Save',
            text: 'Form validated successfully. Backend integration pending.',
            confirmButtonColor: '#c9a227'
        });
    });

    /* ── Reset ── */
    document.getElementById('btnReset').addEventListener('click', function () {
        Swal.fire({
            title: 'Reset Form?',
            text: 'All entered data will be cleared.',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#c9a227',
            cancelButtonColor: '#aaa',
            confirmButtonText: 'Yes, Reset'
        }).then(function (result) {
            if (result.isConfirmed) {
                document.getElementById('custName').value   = '';
                document.getElementById('custPhone').value  = '';
                document.getElementById('idProofType').selectedIndex = 0;
                document.getElementById('idProofNo').value  = '';
                document.getElementById('addrProofType').selectedIndex = 0;
                document.getElementById('addrProofNo').value = '';
                document.getElementById('goldRateInput').value = '';
                var tbody = document.getElementById('billingBody');
                tbody.innerHTML = '';
                rowCount = 0;
                tbody.appendChild(createRow());
                updateTotals();
                (function setDefaults() {
                    var now = new Date();
                    var yyyy = now.getFullYear();
                    var mm   = String(now.getMonth() + 1).padStart(2, '0');
                    var dd   = String(now.getDate()).padStart(2, '0');
                    document.getElementById('billDate').value = yyyy + '-' + mm + '-' + dd;
                    var hh = String(now.getHours()).padStart(2, '0');
                    var mi = String(now.getMinutes()).padStart(2, '0');
                    document.getElementById('billTime').value = hh + ':' + mi;
                })();
            }
        });
    });

    /* ── Customer Autocomplete (jQuery UI) ── */
    /* Dummy data – replace source URL with real servlet endpoint returning [{label, value, phone}] */
    var customerData = [];

    $('#custName').autocomplete({
        minLength: 1,
        source: function (req, res) {
            /* TODO: replace with real AJAX
            $.getJSON(contextPath + '/gold/goldBill/getCustomers.jsp', { q: req.term }, function(data){ res(data); });
            */
            var term = req.term.toLowerCase();
            res(customerData.filter(function (c) {
                return c.label.toLowerCase().indexOf(term) >= 0;
            }));
        },
        select: function (e, ui) {
            $('#custName').val(ui.item.label);
            $('#custPhone').val(ui.item.phone || '');
            return false;
        }
    });

    $('#custPhone').autocomplete({
        minLength: 1,
        source: function (req, res) {
            var term = req.term;
            res(customerData.filter(function (c) {
                return (c.phone || '').indexOf(term) >= 0;
            }).map(function (c) {
                return { label: c.phone + '  –  ' + c.label, value: c.phone, name: c.label };
            }));
        },
        select: function (e, ui) {
            $('#custPhone').val(ui.item.value);
            $('#custName').val(ui.item.name || '');
            return false;
        }
    });

})();
</script>
</body>
</html>
