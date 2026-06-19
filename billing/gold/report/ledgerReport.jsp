<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<jsp:useBean id="goldBean" class="gold.goldBillingBean" />
<%!
    private String csvCell(Object val) {
        String s = val == null ? "" : String.valueOf(val);
        s = s.replace("\r", " ").replace("\n", " ").replace("\"", "\"\"");
        return "\"" + s + "\"";
    }

    private String enc(String s) throws Exception {
        return URLEncoder.encode(s == null ? "" : s, "UTF-8");
    }
%>
<%
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");
    String cidParam = request.getParameter("customerId");
    String download = request.getParameter("download");
    int customerId = 0;
    try { customerId = Integer.parseInt(cidParam); } catch (Exception e) {}

    if (fromDate == null || fromDate.trim().isEmpty()) {
        java.time.LocalDate today = java.time.LocalDate.now();
        fromDate = today.withDayOfMonth(1).toString();
    }
    if (toDate == null || toDate.trim().isEmpty()) {
        toDate = java.time.LocalDate.now().toString();
    }

    Vector rows = goldBean.getLedgerReport(fromDate, toDate, customerId);
    String csvHref = "?fromDate=" + enc(fromDate) + "&toDate=" + enc(toDate) + "&customerId=" + customerId + "&download=csv";

    if ("csv".equalsIgnoreCase(download)) {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=gold_ledger_report.csv");
        StringBuilder csv = new StringBuilder();
        csv.append("ID,Date,Time,Cust ID,Customer,Bill ID,Type,Opening,Amount,Closing,User,Description\n");
        for (int i = 0; i < rows.size(); i++) {
            Vector r = (Vector) rows.get(i);
            csv.append(csvCell(r.get(0))).append(',')
               .append(csvCell(r.get(1))).append(',')
               .append(csvCell(r.get(2))).append(',')
               .append(csvCell(r.get(3))).append(',')
               .append(csvCell(r.get(4))).append(',')
               .append(csvCell(r.get(5))).append(',')
               .append(csvCell(r.get(6))).append(',')
               .append(csvCell(r.get(7))).append(',')
               .append(csvCell(r.get(8))).append(',')
               .append(csvCell(r.get(9))).append(',')
               .append(csvCell(r.get(10))).append(',')
               .append(csvCell(r.get(12))).append('\n');
        }
        out.print(csv.toString());
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Gold Ledger Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/assets/common/head.jsp" %>
    <style>
        .glr-card { background:#fff; border-radius:.7rem; box-shadow:0 2px 10px rgba(0,0,0,.08); padding:16px; }
        .glr-title { font-size:.85rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; color:#1a2540; }
        .glr-table { width:100%; border-collapse:collapse; min-width:960px; }
        .glr-table th { background:#1a2540; color:#fff; font-size:.68rem; text-transform:uppercase; letter-spacing:.7px; padding:8px; border:1px solid #24365f; }
        .glr-table td { padding:7px 8px; border:1px solid #ececec; font-size:.78rem; }
        .num { text-align:right; font-variant-numeric:tabular-nums; }
        .muted { color:#888; }
    </style>
</head>
<body>
<%@ include file="/assets/navbar/navbar.jsp" %>
<%
    request.setAttribute("pageTitle", "Gold Ledger Report");
    request.setAttribute("pageSubtitle", "Opening, debit/credit and closing balances");
    request.setAttribute("pageIcon", "fa-solid fa-book");
%>
<jsp:include page="/assets/common/pageHeader.jsp" />

<div class="container-fluid mt-3 mst-page pb-4" style="max-width:1200px;">
    <div class="glr-card mb-3">
        <form method="get" class="row g-2 align-items-end">
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="date" id="fromDate" name="fromDate" class="form-control" value="<%= fromDate %>">
                <label>From Date</label>
            </div>
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="date" id="toDate" name="toDate" class="form-control" value="<%= toDate %>">
                <label>To Date</label>
            </div>
            <div class="col-md-3 col-sm-6 input-outline">
                <input type="number" id="customerId" name="customerId" class="form-control" value="<%= customerId > 0 ? customerId : "" %>" placeholder=" ">
                <label>Customer ID (optional)</label>
            </div>
            <div class="col-md-3 col-sm-6">
                <button class="btn btn-primary w-100" style="height:38px;">Filter</button>
            </div>
        </form>
    </div>

    <div class="glr-card">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="glr-title mb-0"><i class="fa-solid fa-list me-2"></i>Ledger Entries</div>
            <a href="<%= csvHref %>" class="btn btn-sm btn-outline-primary">
                <i class="fa-solid fa-file-csv me-1"></i>Download CSV
            </a>
        </div>
        <div style="overflow:auto;">
            <table class="glr-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Cust ID</th>
                        <th>Customer</th>
                        <th>Bill ID</th>
                        <th>Type</th>
                        <th>Opening</th>
                        <th>Amount</th>
                        <th>Closing</th>
                        <th>User</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (rows == null || rows.size() == 0) {
                %>
                    <tr>
                        <td colspan="12" class="muted" style="text-align:center; padding:18px;">No ledger entries found for selected filter.</td>
                    </tr>
                <%
                    } else {
                        for (int i = 0; i < rows.size(); i++) {
                            Vector r = (Vector) rows.get(i);
                %>
                    <tr>
                        <td><%= r.get(0) %></td>
                        <td><%= r.get(1) %></td>
                        <td><%= r.get(2) %></td>
                        <td><%= r.get(3) == null ? "" : r.get(3) %></td>
                        <td><%= r.get(4) %></td>
                        <td><%= r.get(5) == null ? "" : r.get(5) %></td>
                        <td><%= r.get(6) %></td>
                        <td class="num"><%= r.get(7) %></td>
                        <td class="num"><%= r.get(8) %></td>
                        <td class="num"><%= r.get(9) %></td>
                        <td><%= r.get(10) %></td>
                        <td><%= r.get(12) == null ? "" : r.get(12) %></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
