<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<jsp:useBean id="goldBean" class="gold.goldBillingBean" />
<jsp:useBean id="userBean" class="user.userBean" />
<%!
    private String csvCell(Object val) {
        String s = val == null ? "" : String.valueOf(val);
        s = s.replace("\r", " ").replace("\n", " ").replace("\"", "\"\"");
        return "\"" + s + "\"";
    }

    private String enc(String s) throws Exception {
        return URLEncoder.encode(s == null ? "" : s, "UTF-8");
    }

    private String formatDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return "";
        try {
            String[] parts = dateStr.split("-");
            if (parts.length == 3) {
                return parts[2] + "-" + parts[1] + "-" + parts[0];
            }
        } catch (Exception e) {}
        return dateStr;
    }

    private String formatDateTime(String dtStr) {
        if (dtStr == null || dtStr.trim().isEmpty()) return "";
        try {
            String[] parts = dtStr.split(" ");
            String datePart = formatDate(parts[0]);
            if (parts.length > 1) return datePart + " " + parts[1];
            return datePart;
        } catch (Exception e) {}
        return dtStr;
    }
%>
<%
    String download = request.getParameter("download");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    if (fromDate == null || fromDate.trim().isEmpty()) {
        fromDate = java.time.LocalDate.now().withDayOfMonth(1).toString();
    }
    if (toDate == null || toDate.trim().isEmpty()) {
        toDate = java.time.LocalDate.now().toString();
    }

    Vector rows = goldBean.getCancelledBillReport(fromDate, toDate);
    String csvHref = "?fromDate=" + enc(fromDate) + "&toDate=" + enc(toDate) + "&download=csv";

    double totGross = 0, totMargin = 0, totNet = 0, totRelease = 0, totPaid = 0;
    for (int i = 0; i < rows.size(); i++) {
        Vector r = (Vector) rows.get(i);
        try { totGross += Double.parseDouble(String.valueOf(r.get(8))); } catch (Exception e) {}
        try { totMargin += Double.parseDouble(String.valueOf(r.get(9))); } catch (Exception e) {}
        try { totNet += Double.parseDouble(String.valueOf(r.get(10))); } catch (Exception e) {}
        try { totRelease += Double.parseDouble(String.valueOf(r.get(11))); } catch (Exception e) {}
        try { totPaid += Double.parseDouble(String.valueOf(r.get(12))); } catch (Exception e) {}
    }

    if ("csv".equalsIgnoreCase(download)) {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=gold_cancel_report.csv");
        StringBuilder csv = new StringBuilder();
        csv.append("Bill No,Bill Date,Bill Time,Cust ID,Customer Name,Phone,Gross,Margin,Net,Release,Amount Paid,Cancelled By,Cancelled Date\n");
        for (int i = 0; i < rows.size(); i++) {
            Vector r = (Vector) rows.get(i);
            String custId = r.get(4) == null || r.get(4).toString().trim().isEmpty() ? "" : "THIR-" + r.get(4);
            String userName = "";
            try {
                if (r.get(13) != null && !r.get(13).toString().trim().isEmpty()) {
                    userName = userBean.getUserName(Integer.parseInt(r.get(13).toString()));
                    if (userName == null) userName = r.get(13).toString();
                }
            } catch (Exception e) {
                userName = r.get(13) == null ? "" : r.get(13).toString();
            }
            csv.append(csvCell(r.get(1))).append(',')
               .append(csvCell(formatDate(String.valueOf(r.get(2))))).append(',')
               .append(csvCell(r.get(3))).append(',')
               .append(csvCell(custId)).append(',')
               .append(csvCell(r.get(5))).append(',')
               .append(csvCell(r.get(6))).append(',')
               .append(csvCell(r.get(8))).append(',')
               .append(csvCell(r.get(9))).append(',')
               .append(csvCell(r.get(10))).append(',')
               .append(csvCell(r.get(11))).append(',')
               .append(csvCell(r.get(12))).append(',')
               .append(csvCell(userName)).append(',')
               .append(csvCell(formatDateTime(String.valueOf(r.get(14))))).append('\n');
        }
        csv.append(csvCell("TOTAL")).append(',')
           .append(csvCell("")).append(',').append(csvCell(""))
           .append(',').append(csvCell("")).append(',').append(csvCell(""))
           .append(',').append(csvCell(""))
           .append(',').append(csvCell(String.format("%.2f", totGross)))
           .append(',').append(csvCell(String.format("%.2f", totMargin)))
           .append(',').append(csvCell(String.format("%.2f", totNet)))
           .append(',').append(csvCell(String.format("%.2f", totRelease)))
           .append(',').append(csvCell(String.format("%.2f", totPaid)))
           .append(',').append(csvCell("")).append(',').append(csvCell(""))
           .append('\n');
        out.print(csv.toString());
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Gold Cancel Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/assets/common/head.jsp" %>
    <style>
        .gcr-card { background:#fff; border-radius:.7rem; box-shadow:0 2px 10px rgba(0,0,0,.08); padding:16px; }
        .gcr-title { font-size:.85rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; color:#1a2540; }
        .gcr-table { width:100%; border-collapse:collapse; min-width:1200px; }
        .gcr-table th { background:#7f1d1d; color:#fff; font-size:.68rem; text-transform:uppercase; letter-spacing:.7px; padding:8px; border:1px solid #991b1b; }
        .gcr-table td { padding:8px 10px; border:1px solid #ececec; font-size:.9rem; font-weight:600; color:#1a2540; }
        .num { text-align:right; font-variant-numeric:tabular-nums; }
        .muted { color:#888; }
        .total-row td { font-weight:700; background:#fef2f2; }
        .cancel-badge { display:inline-block; background:#fee2e2; color:#b91c1c; font-size:.7rem; font-weight:700; padding:2px 8px; border-radius:999px; }
    </style>
</head>
<body>
<%@ include file="/assets/navbar/navbar.jsp" %>
<%
    request.setAttribute("pageTitle", "Gold Cancel Report");
    request.setAttribute("pageSubtitle", "Cancelled bills between selected dates");
    request.setAttribute("pageIcon", "fa-solid fa-ban");
%>
<jsp:include page="/assets/common/pageHeader.jsp" />

<div class="container-fluid mt-3 mst-page pb-4" style="max-width:1280px;">
    <div class="gcr-card mb-3">
        <form method="get" class="row g-2 align-items-end">
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="date" id="fromDate" name="fromDate" class="form-control" value="<%= fromDate %>">
                <label>From Cancel Date</label>
            </div>
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="date" id="toDate" name="toDate" class="form-control" value="<%= toDate %>">
                <label>To Cancel Date</label>
            </div>
            <div class="col-md-3 col-sm-12">
                <button class="btn btn-danger w-100" style="height:38px;">Run Report</button>
            </div>
        </form>
    </div>

    <div class="gcr-card">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="gcr-title mb-0"><i class="fa-solid fa-ban me-2"></i>Cancelled Bills <span class="cancel-badge"><%= rows.size() %> records</span></div>
            <a href="<%= csvHref %>" class="btn btn-sm btn-outline-danger">
                <i class="fa-solid fa-file-csv me-1"></i>Download CSV
            </a>
        </div>
        <div style="overflow:auto;">
            <table class="gcr-table">
                <thead>
                    <tr>
                        <th>Bill No</th>
                        <th>Bill Date</th>
                        <th>Bill Time</th>
                        <th>Cust ID</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Gross</th>
                        <th>Margin</th>
                        <th>Net</th>
                        <th>Release</th>
                        <th>Amount Paid</th>
                        <th>Cancelled By</th>
                        <th>Cancelled Date</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (rows == null || rows.size() == 0) {
                %>
                    <tr>
                        <td colspan="13" class="muted" style="text-align:center; padding:18px;">No cancelled bills found for selected dates.</td>
                    </tr>
                <%
                    } else {
                        for (int i = 0; i < rows.size(); i++) {
                            Vector r = (Vector) rows.get(i);
                            String custId = r.get(4) == null || r.get(4).toString().trim().isEmpty() ? "" : "THIR-" + r.get(4);
                            String userName = "";
                            try {
                                if (r.get(13) != null && !r.get(13).toString().trim().isEmpty()) {
                                    userName = userBean.getUserName(Integer.parseInt(r.get(13).toString()));
                                    if (userName == null) userName = r.get(13).toString();
                                }
                            } catch (Exception e) {
                                userName = r.get(13) == null ? "" : r.get(13).toString();
                            }
                %>
                    <tr>
                        <td><%= r.get(1) %></td>
                        <td><%= formatDate(String.valueOf(r.get(2))) %></td>
                        <td><%= r.get(3) %></td>
                        <td><%= custId %></td>
                        <td><%= r.get(5) %></td>
                        <td><%= r.get(6) == null ? "" : r.get(6) %></td>
                        <td class="num"><%= r.get(8) %></td>
                        <td class="num"><%= r.get(9) %></td>
                        <td class="num"><%= r.get(10) %></td>
                        <td class="num"><%= r.get(11) %></td>
                        <td class="num"><%= r.get(12) %></td>
                        <td><%= userName %></td>
                        <td><%= formatDateTime(String.valueOf(r.get(14))) %></td>
                    </tr>
                <%
                        }
                    }
                %>
                <tr class="total-row">
                    <td colspan="6" class="num">TOTAL</td>
                    <td class="num"><%= String.format("%.2f", totGross) %></td>
                    <td class="num"><%= String.format("%.2f", totMargin) %></td>
                    <td class="num"><%= String.format("%.2f", totNet) %></td>
                    <td class="num"><%= String.format("%.2f", totRelease) %></td>
                    <td class="num"><%= String.format("%.2f", totPaid) %></td>
                    <td colspan="2"></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
