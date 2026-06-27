<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, java.sql.*, javax.naming.*, javax.sql.*" %>
<jsp:useBean id="goldBean" class="gold.goldBillingBean" />
<jsp:useBean id="userBean" class="user.userBean" />
<%!
    // Number to Words conversion (Indian numbering system)
    public String convertToWords(long number) {
        if (number == 0) return "ZERO";
        
        String[] ones = {"", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE"};
        String[] teens = {"TEN", "ELEVEN", "TWELVE", "THIRTEEN", "FOURTEEN", "FIFTEEN", "SIXTEEN", "SEVENTEEN", "EIGHTEEN", "NINETEEN"};
        String[] tens = {"", "", "TWENTY", "THIRTY", "FORTY", "FIFTY", "SIXTY", "SEVENTY", "EIGHTY", "NINETY"};
        
        StringBuilder words = new StringBuilder();
        
        if (number >= 10000000) {
            long crores = number / 10000000;
            words.append(convertToWords(crores)).append(" CRORE ");
            number %= 10000000;
        }
        
        if (number >= 100000) {
            long lakhs = number / 100000;
            words.append(convertToWords(lakhs)).append(" LAKH ");
            number %= 100000;
        }
        
        if (number >= 1000) {
            long thousands = number / 1000;
            words.append(convertToWords(thousands)).append(" THOUSAND ");
            number %= 1000;
        }
        
        if (number >= 100) {
            long hundreds = number / 100;
            words.append(ones[(int)hundreds]).append(" HUNDRED ");
            number %= 100;
        }
        
        if (number >= 20) {
            words.append(tens[(int)(number / 10)]).append(" ");
            number %= 10;
        } else if (number >= 10) {
            words.append(teens[(int)(number - 10)]).append(" ");
            number = 0;
        }
        
        if (number > 0) {
            words.append(ones[(int)number]).append(" ");
        }
        
        return words.toString().trim();
    }
%>
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

    String billNo      = bill.get(1).toString();
    String custId      = bill.get(2) != null ? bill.get(2).toString() : "";
    String custName    = bill.get(3) != null ? bill.get(3).toString() : "-";
    String custPhone   = bill.get(4) != null ? bill.get(4).toString() : "-";
    String idProof     = bill.get(5) != null ? bill.get(5).toString() : "";
    String addrProof   = bill.get(6) != null ? bill.get(6).toString() : "";
    String goldRate    = bill.get(7).toString();
    String grossAmt    = bill.get(8).toString();
    String margin      = bill.get(9).toString();
    String netAmt      = bill.get(10).toString();
    String release     = bill.get(11).toString();
    String amtPaid     = bill.get(12).toString();
    String billDate    = bill.get(13).toString();
    String billTime    = bill.get(14).toString();
    String enteredDt   = bill.get(15).toString();
    
    String formattedCustId = custId.isEmpty() ? "-" : "THIR-" + custId;

    String shopName  = comp.size() > 1 ? comp.get(1).toString() : "";
    String shopAddr  = comp.size() > 2 ? comp.get(2).toString() : "";
    String shopGstin = comp.size() > 3 ? comp.get(3).toString() : "";
    
    // Fetch customer address from customers table
    String customerAddress = "-";
    if (!custId.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/golddb");
            con = ds.getConnection();
            ps = con.prepareStatement("SELECT address FROM customers WHERE id = ?");
            ps.setInt(1, Integer.parseInt(custId));
            rs = ps.executeQuery();
            if (rs.next()) {
                customerAddress = rs.getString("address");
                if (customerAddress == null || customerAddress.trim().isEmpty()) {
                    customerAddress = "-";
                }
            }
        } catch (Exception e) {
            customerAddress = "-";
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (ps != null) try { ps.close(); } catch(Exception e) {}
            if (con != null) try { con.close(); } catch(Exception e) {}
        }
    }

    DecimalFormat df = new DecimalFormat("##,##,##0.00");
    DecimalFormat df0 = new DecimalFormat("##,##,##0");
    double dGross  = Double.parseDouble(grossAmt);
    double dMargin = Double.parseDouble(margin);
    double dNet    = Double.parseDouble(netAmt);
    double dRelease = Double.parseDouble(release);
    double dPaid   = Double.parseDouble(amtPaid);

    double totalGrossWt = 0, totalStoneWax = 0, totalNetWt = 0, totalGrossAmt = 0;
    for (int i = 0; i < items.size(); i++) {
        Vector row = (Vector) items.get(i);
        totalGrossWt  += Double.parseDouble(row.get(1).toString());
        totalStoneWax += Double.parseDouble(row.get(2).toString());
        totalNetWt    += Double.parseDouble(row.get(3).toString());
        totalGrossAmt += Double.parseDouble(row.get(5).toString());
    }
    
    String amountInWords = "RUPEES " + convertToWords((long)dPaid) + " ONLY";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Invoice #<%= billNo %> - <%= shopName %></title>
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background: #fff;
        padding: 8px;
        color: #111;
        font-size: 12px;
        line-height: 1.35;
    }

    .bill-container {
        width: 100%;
        max-width: 820px;
        margin: 0 auto;
        background: #fff;
        border: 1px solid #444;
    }

    .header {
        background: linear-gradient(135deg, #111a3a 0%, #102c57 60%, #0f3d73 100%);
        padding: 12px 14px 10px;
        border-bottom: none;
    }

    .logo-section {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .logo-img {
        width: 78px;
        height: 78px;
        object-fit: contain;
        flex-shrink: 0;
        border-radius: 50%;
        border: 4px solid #f3ce48;
        background: radial-gradient(circle at 35% 35%, #ffffff 0%, #f0f0f0 70%, #d8d8d8 100%);
        box-shadow: 0 0 0 2px rgba(243,206,72,0.35), 0 8px 18px rgba(0,0,0,0.35);
        padding: 7px;
    }

    .company-info {
        text-align: center;
        flex: 1;
    }

    .company-name {
        font-size: 19px;
        font-weight: 900;
        color: #fff;
        letter-spacing: 1px;
        text-transform: uppercase;
        line-height: 1.1;
        margin: 0;
    }

    .company-name span {
        color: #f5f7ff;
        font-weight: 800;
    }

    .company-tagline {
        font-size: 12px;
        color: #f3ce48;
        font-weight: 900;
        letter-spacing: 2px;
        margin-top: 3px;
    }

    .company-address {
        font-size: 11px;
        color: #e8f0ff;
        line-height: 1.35;
        margin-top: 3px;
        margin-bottom: 0;
    }

    .company-address strong {
        color: #f3ce48;
    }

    .gold-line {
        height: 3px;
        margin-top: 8px;
        background: linear-gradient(90deg, rgba(243,206,72,0.1) 0%, #f3ce48 35%, #1f4f87 100%);
    }

    .customer-section {
        padding: 8px 0 0;
    }

    .customer-table {
        width: 100%;
        border-collapse: collapse;
        border: 2px solid #555;
    }

    .customer-table td {
        padding: 8px 10px;
        border: 1px solid #666;
        font-size: 13px;
        vertical-align: middle;
    }

    .customer-table .label-col {
        background: #efefef;
        font-weight: 700;
        text-transform: uppercase;
        color: #111;
        width: 170px;
    }

    .customer-table .value-col {
        background: #fff;
        font-weight: 600;
        color: #111;
    }

    .customer-table .value-col.gold {
        color: #000;
        font-weight: 900;
        font-size: 15px;
    }

    .customer-table .address-row td {
        font-size: 13px;
        padding: 8px 10px;
    }

    .items-section {
        padding: 0 0 8px;
    }

    .items-table {
        width: 100%;
        border-collapse: collapse;
        border: 2px solid #555;
    }

    .items-table thead {
        background: #efefef;
    }

    .items-table th {
        color: #111;
        padding: 8px 6px;
        text-align: center;
        font-size: 13px;
        font-weight: 800;
        text-transform: uppercase;
        border: 1px solid #666;
    }

    .items-table td {
        padding: 8px 6px;
        text-align: center;
        font-size: 13px;
        font-weight: 600;
        border: 1px solid #777;
    }

    .items-table .total-row {
        background: #102c57 !important;
        color: #ffffff;
        font-weight: 800;
        font-size: 14px;
    }

    .items-table .total-row td {
        color: #ffffff;
        padding: 8px 6px;
        border: 1px solid #777;
        background: #102c57;
    }

    .items-table .gold-value {
        color: #000;
        font-weight: 900;
    }

    .summary-wrapper {
        display: grid;
        grid-template-columns: 1fr 300px;
        border-top: 2px solid #222;
    }

    .terms-column {
        padding: 10px 14px;
        border-right: 2px solid #222;
    }

    .terms-title {
        font-size: 11px;
        font-weight: 800;
        color: #111;
        text-transform: uppercase;
        margin-bottom: 6px;
    }

    .terms-list {
        font-size: 10px;
        line-height: 1.4;
        color: #222;
        padding-left: 14px;
    }

    .terms-list li {
        margin-bottom: 2px;
    }

    .terms-tamil {
        margin-top: 8px;
        padding-top: 6px;
        border-top: 1px solid #aaa;
    }

    .terms-tamil-list {
        font-size: 10px;
        line-height: 1.4;
        color: #222;
        padding-left: 14px;
        font-family: 'Noto Sans Tamil', 'Latha', 'Arial Unicode MS', sans-serif;
    }

    .terms-tamil-list li {
        margin-bottom: 2px;
    }

    .summary-column {
        padding: 10px 14px;
        background: #fff;
    }

    .summary-table {
        width: 100%;
    }

    .summary-row {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        border-bottom: 1px solid #aaa;
        font-size: 12px;
    }

    .summary-label {
        color: #111;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 12px;
    }

    .summary-value {
        color: #111;
        font-weight: 800;
        font-size: 13px;
    }

    .summary-row.grand-total {
        border-top: 2px solid #222;
        border-bottom: 2px solid #222;
        padding: 8px 0;
        margin-top: 6px;
        background: linear-gradient(90deg, #111a3a 0%, #153f72 100%);
        border-radius: 6px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        padding-left: 10px;
        padding-right: 10px;
    }

    .summary-row.grand-total .summary-label {
        font-size: 13px;
        font-weight: 900;
        letter-spacing: 0.8px;
        color: #f6d768;
        white-space: nowrap;
    }

    .summary-row.grand-total .summary-value {
        font-size: 21px;
        font-weight: 900;
        letter-spacing: 0.5px;
        color: #ffffff;
        font-family: 'Trebuchet MS', 'Segoe UI', Arial, sans-serif;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.35);
        white-space: nowrap;
    }

    .amount-words {
        padding: 8px 14px;
        border-top: 2px solid #222;
        font-size: 12px;
        font-weight: 700;
        color: #111;
    }

    .amount-words-label {
        font-size: 11px;
        color: #444;
        text-transform: uppercase;
        margin-bottom: 2px;
        font-weight: 700;
    }

    .amount-words-value {
        font-size: 14px;
        color: #000;
        font-weight: 800;
        text-transform: uppercase;
    }

    .signature-section {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        border-top: 2px solid #222;
    }

    .signature-box {
        padding: 20px 12px 10px;
        text-align: center;
        border-right: 1px solid #777;
        min-height: 64px;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
    }

    .signature-box:last-child {
        border-right: none;
    }

    .signature-label {
        font-size: 12px;
        font-weight: 700;
        color: #111;
        text-transform: uppercase;
        border-top: 1px solid #222;
        padding-top: 6px;
        margin-top: 20px;
    }

    .footer {
        background: #f2f2f2;
        padding: 8px 14px;
        text-align: center;
        color: #111;
        font-size: 11px;
        border-top: 1px solid #777;
    }

    .footer strong {
        color: #111;
    }

    .print-button {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: #222;
        color: #fff;
        border: none;
        padding: 10px 18px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 700;
        cursor: pointer;
        z-index: 1000;
        text-transform: uppercase;
    }

    @media print {
        body {
            padding: 0;
        }

        .bill-container {
            max-width: 100%;
            border: none;
        }

        .print-button {
            display: none;
        }

        .summary-row.grand-total {
            box-shadow: none;
        }
    }

    @media (max-width: 640px) {
        .summary-row.grand-total .summary-value {
            font-size: 18px;
        }

        .summary-row.grand-total .summary-label {
            font-size: 12px;
        }
    }
</style>
</head>
<body>

<button class="print-button no-print" onclick="window.print()">🖨️ PRINT INVOICE</button>

<div class="bill-container">
    
    <!-- ═══ PREMIUM HEADER ═══ -->
    <div class="header">
        <div class="logo-section">
            <img src="logo.png" alt="Logo" class="logo-img">
            <div class="company-info">
                <div class="company-name"><%= shopName %> <span>திருமலா கோல்டு பையர்ஸ்</span></div>
                <div class="company-tagline">GOLD BUYERS & TRADERS</div>
                <div class="company-address">
                    <%= shopAddr %><br>
                    <% if(!shopGstin.isEmpty()){ %><strong>GSTIN:</strong> <%= shopGstin %> | <% } %>
                    <strong>Contact:</strong> 8778630760
                </div>
            </div>
        </div>
        <div class="gold-line"></div>
    </div>
    
    <!-- ═══ CUSTOMER INFO ═══ -->
    <div class="customer-section">
        <table class="customer-table">
            <tr>
                <td class="label-col">CUSTOMER NAME</td>
                <td class="value-col"><%= custName %></td>
                <td class="label-col">DATE / TIME</td>
                <td class="value-col"><%= billDate %> <%= billTime %></td>
            </tr>
            <tr>
                <td class="label-col">CONTACT</td>
                <td class="value-col"><%= custPhone %></td>
                <td class="label-col">GOLD PRICE</td>
                <td class="value-col gold"><%= goldRate %></td>
            </tr>
            <tr class="address-row">
                <td class="label-col">Address</td>
                <td colspan="3" class="value-col" style="white-space: pre-line;"><%= customerAddress %></td>
            </tr>
            <tr>
                <td class="label-col">ID PROOF</td>
                <td class="value-col"><%= idProof.isEmpty() ? "-" : idProof %></td>
                <td class="label-col">ADDRESS PROOF</td>
                <td class="value-col"><%= addrProof.isEmpty() ? "-" : addrProof %></td>
            </tr>
        </table>
    </div>
    
    <!-- ═══ ITEMS TABLE ═══ -->
    <div class="items-section">
        <table class="items-table">
            <thead>
                <tr>
                    <th>S.NO</th>
                    <th>ORNAMENT TYPE</th>
                    <th>GROSS WT (g)</th>
                    <th>STONE/WAX (g)</th>
                    <th>NET WT (g)</th>
                    <th>PURITY</th>
                    <th>AMOUNT (₹)</th>
                </tr>
            </thead>
            <tbody>
                <% 
                for (int i = 0; i < items.size(); i++) {
                    Vector row = (Vector) items.get(i);
                    String ornType = row.get(0).toString();
                    double gwt = Double.parseDouble(row.get(1).toString());
                    double swt = Double.parseDouble(row.get(2).toString());
                    double nwt = Double.parseDouble(row.get(3).toString());
                    String pur = row.get(4).toString();
                    double amt = Double.parseDouble(row.get(5).toString());
                %>
                <tr>
                    <td><%= (i+1) %></td>
                    <td style="text-align:left; padding-left:15px;"><strong><%= ornType %></strong></td>
                    <td class="gold-value"><%= df.format(gwt) %></td>
                    <td><%= df.format(swt) %></td>
                    <td class="gold-value"><%= df.format(nwt) %></td>
                    <td><%= pur %></td>
                    <td class="gold-value">₹ <%= df.format(amt) %></td>
                </tr>
                <% } %>
                <tr class="total-row">
                    <td colspan="2" style="text-align:right; padding-right:15px;">TOTAL</td>
                    <td class="gold-value"><%= df.format(totalGrossWt) %></td>
                    <td><%= df.format(totalStoneWax) %></td>
                    <td class="gold-value"><%= df.format(totalNetWt) %></td>
                    <td>-</td>
                    <td class="gold-value">₹ <%= df.format(totalGrossAmt) %></td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <!-- ═══ SUMMARY & TERMS ═══ -->
    <div class="summary-wrapper">
        <div class="terms-column">
            <div class="terms-title">Terms & Conditions</div>
            <ul class="terms-list">
                <li>Ornaments once purchased shall not be returned under any circumstances.</li>
                <li>If any losses arise out of this purchase, you shall be liable to pay the full amount.</li>
                <li>Selling stolen gold, silver, or fake gold is a criminal offence. If detected, it will be reported to the authorities.</li>
                <li>The ornaments were purchased from you based on your declaration that you hold the ownership and saleable title to the ornaments.</li>
                <li>Kindly ensure the correctness of the cash before leaving the counter. No claims for any shortage will be entertained thereafter.</li>
            </ul>
            
            <div class="terms-tamil">
                <div class="terms-title">விதிமுறைகள் மற்றும் நிபந்தனைகள்</div>
                <ul class="terms-tamil-list">
                    <li>ஒருமுறை வாங்கிய ஆபரணங்கள் எந்த சூழ்நிலையிலும் திரும்பக் கொடுக்கப்படாது.</li>
                    <li>இந்த வாங்குதலில் ஏதேனும் இழப்புகள் ஏற்பட்டால், நீங்கள் முழுத் தொகையையும் செலுத்த வேண்டும்.</li>
                    <li>திருடப்பட்ட தங்கம், வெள்ளி அல்லது போலி தங்கத்தை விற்பனை செய்வது கிரிமினல் குற்றமாகும். அது கண்டுபிடிக்கப்பட்டால் சம்பந்தப்பட்ட அதிகாரிகளுக்குத் தெரிவிக்கப்படும்.</li>
                    <li>ஆபரணங்கள் மீதான உரிமை மற்றும் விற்பனை உரிமை உங்களிடம் உள்ளது என்ற அறிவிப்பின் அடிப்படையில், உங்களிடமிருந்து ஆபரணங்கள் வாங்கப்பட்டன.</li>
                    <li>கவுண்டரை விட்டு வெளியேறும் முன், பணத்தின் சரியான தன்மையை உறுதிசெய்து கொள்ளுங்கள்.</li>
                </ul>
            </div>
        </div>
        
        <div class="summary-column">
            <div class="summary-table">
                <div class="summary-row">
                    <div class="summary-label">Gross Amount</div>
                    <div class="summary-value">₹ <%= df.format(dGross) %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Margin</div>
                    <div class="summary-value">₹ <%= df.format(dMargin) %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Net Amount</div>
                    <div class="summary-value">₹ <%= df.format(dNet) %></div>
                </div>
                <div class="summary-row">
                    <div class="summary-label">Release Amount</div>
                    <div class="summary-value">₹ <%= df.format(dRelease) %></div>
                </div>
                <div class="summary-row grand-total">
                    <div class="summary-label">Amount Paid</div>
                    <div class="summary-value">₹ <%= df.format(dPaid) %></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- ═══ AMOUNT IN WORDS ═══ -->
    <div class="amount-words">
        <div class="amount-words-label">Amount in Words</div>
        <div class="amount-words-value">
            <%= amountInWords %>
        </div>
    </div>
    
    <!-- ═══ SIGNATURES ═══ -->
    <div class="signature-section">
        <div class="signature-box">
            <div class="signature-label">Thumb Impression</div>
        </div>
        <div class="signature-box">
            <div class="signature-label">Customer Signature</div>
        </div>
    </div>
    
    <!-- ═══ FOOTER ═══ -->
    <div class="footer">
        This is a computer generated invoice | <strong>Thank you for your business!</strong> | For queries: contact@<%= shopName.toLowerCase().replace(" ", "") %>.com
    </div>
    
</div>

<script>
window.addEventListener('load', function() {
    setTimeout(function() {
        window.print();
    }, 500);
});

window.addEventListener('afterprint', function() {
    window.close();
});
</script>

</body>
</html>
