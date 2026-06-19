<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*" %>
<jsp:useBean id="goldBean" class="gold.goldBillingBean" />
<jsp:useBean id="userBean" class="user.userBean" />
<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        out.print("Missing bill id"); return;
    }
    int billId = Integer.parseInt(idParam.trim());

    Vector bill  = goldBean.getBillById(billId);
    Vector items = goldBean.getBillItems(billId);
    Vector comp  = userBean.getCompanyDetails();

    if (bill == null || bill.isEmpty()) {
        out.print("Bill not found"); return;
    }

    // bill: [0]id [1]bill_no [2]cust_name [3]cust_phone [4]id_proof [5]addr_proof
    //       [6]gold_rate [7]gross_amount [8]margin [9]net_amount [10]release [11]amount_paid
    //       [12]bill_date [13]bill_time [14]entered_dt
    String billNo      = bill.get(1).toString();
    String custName    = bill.get(2) != null ? bill.get(2).toString() : "-";
    String custPhone   = bill.get(3) != null ? bill.get(3).toString() : "-";
    String idProof     = bill.get(4) != null ? bill.get(4).toString() : "";
    String addrProof   = bill.get(5) != null ? bill.get(5).toString() : "";
    String goldRate    = bill.get(6).toString();
    String grossAmt    = bill.get(7).toString();
    String margin      = bill.get(8).toString();
    String netAmt      = bill.get(9).toString();
    String release     = bill.get(10).toString();
    String amtPaid     = bill.get(11).toString();
    String billDate    = bill.get(12).toString();
    String billTime    = bill.get(13).toString();
    String enteredDt   = bill.get(14).toString();

    // company: [0]id [1]shop_name [2]address [3]gstin
    String shopName  = comp.size() > 1 ? comp.get(1).toString() : "";
    String shopAddr  = comp.size() > 2 ? comp.get(2).toString() : "";
    String shopGstin = comp.size() > 3 ? comp.get(3).toString() : "";

    // Format numbers Indian style
    DecimalFormat df = new DecimalFormat("##,##,##0.00");
    DecimalFormat df0 = new DecimalFormat("##,##,##0");
    double dGross  = Double.parseDouble(grossAmt);
    double dMargin = Double.parseDouble(margin);
    double dNet    = Double.parseDouble(netAmt);
    double dRelease = Double.parseDouble(release);
    double dPaid   = Double.parseDouble(amtPaid);

    // Total row accumulators
    double totalGrossWt = 0, totalStoneWax = 0, totalNetWt = 0, totalGrossAmt = 0;
    for (int i = 0; i < items.size(); i++) {
        Vector row = (Vector) items.get(i);
        totalGrossWt  += Double.parseDouble(row.get(1).toString());
        totalStoneWax += Double.parseDouble(row.get(2).toString());
        totalNetWt    += Double.parseDouble(row.get(3).toString());
        totalGrossAmt += Double.parseDouble(row.get(5).toString());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Gold Bill #<%= billNo %></title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
        font-family: Arial, Helvetica, sans-serif;
        font-size: 11px;
        color: #000;
        background: #fff;
        padding: 10px;
    }
    .bill-wrap {
        max-width: 750px;
        margin: 0 auto;
        border: 1.5px solid #000;
        padding: 10px 14px;
    }

    /* ── Header ── */
    .hdr { text-align: center; border-bottom: 1.5px solid #000; padding-bottom: 8px; margin-bottom: 6px; }
    .hdr .shop-name { font-size: 20px; font-weight: 900; letter-spacing: 1px; }
    .hdr .branch    { font-size: 10px; margin-top: 3px; }
    .hdr .address   { font-size: 9.5px; margin-top: 2px; color: #333; }

    /* ── Customer info grid ── */
    .info-table { width: 100%; border-collapse: collapse; margin-top: 6px; }
    .info-table td { padding: 4px 6px; border: 1px solid #000; font-size: 10.5px; vertical-align: top; }
    .info-table .lbl { font-weight: 700; width: 110px; background: #f5f5f5; white-space: nowrap; }

    /* ── Billing table ── */
    .bil-table { width: 100%; border-collapse: collapse; margin-top: 8px; }
    .bil-table th {
        background: #222;
        color: #fff;
        padding: 5px 6px;
        font-size: 10px;
        text-transform: uppercase;
        letter-spacing: 0.4px;
        border: 1px solid #000;
        text-align: center;
    }
    .bil-table td {
        padding: 5px 6px;
        border: 1px solid #000;
        text-align: center;
        font-size: 10.5px;
    }
    .bil-table td.left { text-align: left; }
    .bil-table td.right { text-align: right; font-weight: 700; }
    .bil-table tr.total-row td { font-weight: 800; background: #f5f5f5; }

    /* ── Summary + T&C two-col layout ── */
    .bottom-wrap { display: flex; gap: 0; margin-top: 0; border: 1px solid #000; border-top: none; }
    .tc-col { flex: 1; border-right: 1px solid #000; padding: 8px; }
    .summary-col { width: 210px; flex-shrink: 0; }
    .summary-table { width: 100%; border-collapse: collapse; }
    .summary-table td { padding: 5px 8px; border: 1px solid #000; font-size: 10.5px; }
    .summary-table .slbl { font-weight: 700; background: #f5f5f5; border-right: 1px solid #000; }
    .summary-table .sval { text-align: right; font-weight: 700; }
    .summary-table .paid-row td { background: #222; color: #fff; font-size: 11px; }

    /* ── T&C ── */
    .tc-title { font-weight: 800; font-size: 10.5px; text-align: center; margin-bottom: 5px; }
    .tc-list  { padding-left: 14px; font-size: 9px; color: #333; line-height: 1.6; }
    .tc-tamil { font-size: 9px; color: #333; line-height: 1.6; margin-top: 4px; }

    /* ── Thumb + Signature ── */
    .sig-row { display: flex; border-top: 1px solid #000; }
    .sig-cell { flex: 1; text-align: center; padding: 10px 8px 6px; font-size: 10px; font-weight: 700; border-right: 1px solid #000; }
    .sig-cell:last-child { border-right: none; }
    .sig-line { border-top: 1px solid #555; margin-top: 28px; width: 80%; margin-left: auto; margin-right: auto; }

    /* ── Words row ── */
    .words-row { border-top: 1px solid #000; padding: 5px 8px; font-size: 10px; font-weight: 700; text-align: center; }

    @media print {
        body { padding: 0; }
        .bill-wrap { border: none; }
        .no-print { display: none; }
    }
</style>
</head>
<body>

<!-- Print button (hidden on print) -->
<div class="no-print" style="text-align:center; margin-bottom:10px;">
    <button onclick="window.print()"
        style="background:#1a2540; color:#fff; border:none; padding:8px 24px; border-radius:6px; font-size:13px; cursor:pointer;">
        🖨️ Print
    </button>
</div>

<div class="bill-wrap">

    <!-- ══ HEADER ══ -->
    <div class="hdr">
        <div class="shop-name"><%= shopName %></div>
        <div class="branch">BRANCH : <%= shopAddr %><% if(!shopGstin.isEmpty()){ %> &nbsp;|&nbsp; GST NO: <%= shopGstin %><% } %></div>
    </div>

    <!-- ══ CUSTOMER INFO ══ -->
    <table class="info-table">
        <tr>
            <td class="lbl">CUSTOMER NAME</td>
            <td><%= custName %></td>
            <td class="lbl">DATE / TIME</td>
            <td><%= billDate %> <%= billTime %></td>
        </tr>
        <tr>
            <td class="lbl">CONTACT</td>
            <td><%= custPhone.isEmpty() ? "-" : custPhone %></td>
            <td class="lbl">BILL ID</td>
            <td><%= billNo %></td>
        </tr>
        <tr>
            <td class="lbl">ID PROOF</td>
            <td><%= idProof.isEmpty() ? "-" : idProof %></td>
            <td class="lbl">GOLD PRICE</td>
            <td><%= goldRate %></td>
        </tr>
        <tr>
            <td class="lbl">ADDRESS PROOF</td>
            <td colspan="3"><%= addrProof.isEmpty() ? "-" : addrProof %></td>
        </tr>
    </table>

    <!-- ══ BILLING TABLE ══ -->
    <table class="bil-table">
        <thead>
            <tr>
                <th>Ornament Type</th>
                <th>Gross Weight</th>
                <th>Stone / Wax</th>
                <th>Net Weight</th>
                <th>Purity</th>
                <th>Gross Amount</th>
            </tr>
        </thead>
        <tbody>
<%
    for (int i = 0; i < items.size(); i++) {
        Vector row = (Vector) items.get(i);
        double gw  = Double.parseDouble(row.get(1).toString());
        double sw  = Double.parseDouble(row.get(2).toString());
        double nw  = Double.parseDouble(row.get(3).toString());
        double pur = Double.parseDouble(row.get(4).toString());
        double ga  = Double.parseDouble(row.get(5).toString());
%>
            <tr>
                <td class="left"><%= row.get(0) %></td>
                <td><%= new DecimalFormat("0.###").format(gw) %></td>
                <td><%= new DecimalFormat("0.###").format(sw) %></td>
                <td><%= new DecimalFormat("0.###").format(nw) %></td>
                <td><%= new DecimalFormat("0.##").format(pur) %></td>
                <td class="right"><%= df0.format(ga) %></td>
            </tr>
<% } %>
            <tr class="total-row">
                <td class="left"><strong>GRAND TOTAL</strong></td>
                <td><%= new DecimalFormat("0.###").format(totalGrossWt) %></td>
                <td><%= new DecimalFormat("0.###").format(totalStoneWax) %></td>
                <td><%= new DecimalFormat("0.###").format(totalNetWt) %></td>
                <td></td>
                <td class="right"><%= df0.format(totalGrossAmt) %></td>
            </tr>
        </tbody>
    </table>

    <!-- ══ T&C + SUMMARY ══ -->
    <div class="bottom-wrap">
        <!-- Terms & Conditions -->
        <div class="tc-col">
            <div class="tc-title">TERMS &amp; CONDITIONS</div>
            <ol class="tc-list">
                <li>Ornaments once purchased shall not be returned under any circumstances.</li>
                <li>If any losses are arising out of this purchase, then you are liable to settle full amount.</li>
                <li>Selling stolen gold, silver or fake gold is a criminal offence, if found will be reported to authorities.</li>
                <li>Ornaments were purchased from you based on the declaration that you hold the ownership and saleable title on the ornaments and you completely agree to indemnify against any further claim.</li>
                <li>Kindly ensure the correctness of cash before leaving the counter. No claims for shortfall will be entertained thereafter.</li>
            </ol>
            <div class="tc-tamil" style="margin-top:6px; font-weight:700; text-align:center;">விதிமுறை மற்றும் நிபந்தனைகள்</div>
            <ol class="tc-tamil" style="padding-left:14px;">
                <li>ஒருமுறை வாங்கிய ஆபரணங்களை எந்தவொரு சூழ்நிலையிலும் திரும்ப கொடுக்கப்படாது.</li>
                <li>இந்த வாங்குதலில் ஏதேனும் இழப்புகள் ஏற்பட்டால் நீங்கள் முழுத்தொகையை செலுத்த வேண்டும்.</li>
                <li>திருடப்பட்ட தங்கம் விற்பது சட்ட விரோதம்.</li>
            </ol>
            <!-- Thumb + Signature -->
            <div class="sig-row" style="margin-top:10px; border:none;">
                <div class="sig-cell" style="border-right:1px solid #000;">
                    <div style="height:40px;"></div>
                    <div class="sig-line"></div>
                    THUMB IMPRESSION
                </div>
                <div class="sig-cell">
                    <div style="height:40px;"></div>
                    <div class="sig-line"></div>
                    CUSTOMER SIGNATURE
                </div>
            </div>
        </div>

        <!-- Summary -->
        <div class="summary-col">
            <table class="summary-table">
                <tr>
                    <td class="slbl">GROSS AMOUNT</td>
                    <td class="sval"><%= df0.format(dGross) %></td>
                </tr>
                <tr>
                    <td class="slbl">MARGIN</td>
                    <td class="sval"><%= df0.format(dMargin) %></td>
                </tr>
                <tr>
                    <td class="slbl">NET AMOUNT</td>
                    <td class="sval"><%= df0.format(dNet) %></td>
                </tr>
                <tr>
                    <td class="slbl">RELEASE</td>
                    <td class="sval"><%= dRelease > 0 ? df0.format(dRelease) : "" %></td>
                </tr>
                <tr class="paid-row">
                    <td class="slbl" style="color:#fff;">AMOUNT PAID</td>
                    <td class="sval" style="color:#fff;"><%= df0.format(dPaid) %></td>
                </tr>
            </table>
        </div>
    </div>

    <!-- ══ AMOUNT IN WORDS ══ -->
    <div class="words-row">
        AMOUNT IN WORDS : <%= amountToWords((long) Math.round(dPaid)) %> ONLY
    </div>

</div><!-- /bill-wrap -->

<%!
/* ── Amount to words (Indian system) ── */
private String amountToWords(long n) {
    if (n == 0) return "ZERO";
    String[] ones = {"","ONE","TWO","THREE","FOUR","FIVE","SIX","SEVEN","EIGHT","NINE",
                     "TEN","ELEVEN","TWELVE","THIRTEEN","FOURTEEN","FIFTEEN","SIXTEEN",
                     "SEVENTEEN","EIGHTEEN","NINETEEN"};
    String[] tens = {"","","TWENTY","THIRTY","FORTY","FIFTY","SIXTY","SEVENTY","EIGHTY","NINETY"};
    StringBuilder sb = new StringBuilder();
    if (n >= 10000000) { sb.append(amountToWords(n / 10000000)).append(" CRORE "); n %= 10000000; }
    if (n >= 100000)   { sb.append(amountToWords(n / 100000)).append(" LAKH "); n %= 100000; }
    if (n >= 1000)     { sb.append(amountToWords(n / 1000)).append(" THOUSAND "); n %= 1000; }
    if (n >= 100)      { sb.append(ones[(int)(n/100)]).append(" HUNDRED "); n %= 100; }
    if (n >= 20)       { sb.append(tens[(int)(n/10)]); if(n%10!=0) sb.append(" ").append(ones[(int)(n%10)]); sb.append(" "); }
    else if (n > 0)    { sb.append(ones[(int)n]).append(" "); }
    return sb.toString().trim();
}
%>

</body>
</html>
