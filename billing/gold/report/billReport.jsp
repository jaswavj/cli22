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
    String mode = request.getParameter("mode");
    if (mode == null || mode.trim().isEmpty()) mode = "dateCustomer";
    String download = request.getParameter("download");

    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");
    String customerName = request.getParameter("customerName");
    String searchBy = request.getParameter("searchBy");
    String searchText = request.getParameter("searchText");

    if ("dateCustomer".equals(mode)) {
        if (fromDate == null || fromDate.trim().isEmpty()) {
            java.time.LocalDate today = java.time.LocalDate.now();
            fromDate = today.withDayOfMonth(1).toString();
        }
        if (toDate == null || toDate.trim().isEmpty()) {
            toDate = java.time.LocalDate.now().toString();
        }
    }

    if (customerName == null) customerName = "";
    if (searchText == null) searchText = "";
    if (searchBy == null || searchBy.trim().isEmpty()) searchBy = "name";

    Vector rows;
    if ("customerOnly".equals(mode)) {
        rows = goldBean.getBillReport(null, null, searchText, searchBy, true);
    } else {
        rows = goldBean.getBillReport(fromDate, toDate, customerName, "name", false);
    }

    String csvHref;
    if ("customerOnly".equals(mode)) {
        csvHref = "?mode=customerOnly&searchBy=" + enc(searchBy) + "&searchText=" + enc(searchText) + "&download=csv";
    } else {
        csvHref = "?mode=dateCustomer&fromDate=" + enc(fromDate) + "&toDate=" + enc(toDate) + "&customerName=" + enc(customerName) + "&download=csv";
    }

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
        response.setHeader("Content-Disposition", "attachment; filename=gold_bill_report.csv");
        StringBuilder csv = new StringBuilder();
        csv.append("Bill No,Bill Date,Bill Time,Cust ID,Customer Name,Phone,Gold Rate,Gross,Margin,Net,Release,Amount Paid,User\n");
        for (int i = 0; i < rows.size(); i++) {
            Vector r = (Vector) rows.get(i);
            csv.append(csvCell(r.get(1))).append(',')
               .append(csvCell(r.get(2))).append(',')
               .append(csvCell(r.get(3))).append(',')
               .append(csvCell(r.get(4))).append(',')
               .append(csvCell(r.get(5))).append(',')
               .append(csvCell(r.get(6))).append(',')
               .append(csvCell(r.get(7))).append(',')
               .append(csvCell(r.get(8))).append(',')
               .append(csvCell(r.get(9))).append(',')
               .append(csvCell(r.get(10))).append(',')
               .append(csvCell(r.get(11))).append(',')
               .append(csvCell(r.get(12))).append(',')
               .append(csvCell(r.get(13))).append('\n');
        }
        csv.append(csvCell("TOTAL")).append(',')
           .append(csvCell(""))
           .append(',').append(csvCell(""))
           .append(',').append(csvCell(""))
           .append(',').append(csvCell(""))
           .append(',').append(csvCell(""))
           .append(',').append(csvCell(String.format("%.2f", totGross)))
           .append(',').append(csvCell(String.format("%.2f", totMargin)))
           .append(',').append(csvCell(String.format("%.2f", totNet)))
           .append(',').append(csvCell(String.format("%.2f", totRelease)))
           .append(',').append(csvCell(String.format("%.2f", totPaid)))
           .append(',').append(csvCell(""))
           .append('\n');
        out.print(csv.toString());
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Gold Bill Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/assets/common/head.jsp" %>
    <style>
        .gbr-card { background:#fff; border-radius:.7rem; box-shadow:0 2px 10px rgba(0,0,0,.08); padding:16px; }
        .gbr-title { font-size:.85rem; font-weight:700; letter-spacing:1px; text-transform:uppercase; color:#1a2540; }
        .gbr-tabs .nav-link { font-weight:700; color:#4a607f; }
        .gbr-tabs .nav-link.active { color:#1a2540; }
        .gbr-table { width:100%; border-collapse:collapse; min-width:1200px; }
        .gbr-table th { background:#1a2540; color:#fff; font-size:.68rem; text-transform:uppercase; letter-spacing:.7px; padding:8px; border:1px solid #24365f; }
        .gbr-table td { padding:7px 8px; border:1px solid #ececec; font-size:.78rem; }
        .num { text-align:right; font-variant-numeric:tabular-nums; }
        .muted { color:#888; }
        .total-row td { font-weight:700; background:#f8fafc; }
    </style>
</head>
<body>
<%@ include file="/assets/navbar/navbar.jsp" %>
<%
    request.setAttribute("pageTitle", "Gold Bill Report");
    request.setAttribute("pageSubtitle", "Filter by bill date range and customer name/phone");
    request.setAttribute("pageIcon", "fa-solid fa-file-invoice");
%>
<jsp:include page="/assets/common/pageHeader.jsp" />

<div class="container-fluid mt-3 mst-page pb-4" style="max-width:1280px;">
    <div class="gbr-card mb-3">
        <ul class="nav nav-tabs gbr-tabs" id="billReportTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "dateCustomer".equals(mode) ? "active" : "" %>" id="date-customer-tab" data-bs-toggle="tab" data-bs-target="#date-customer-pane" type="button" role="tab" aria-controls="date-customer-pane" aria-selected="<%= "dateCustomer".equals(mode) ? "true" : "false" %>">Date + Name</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%= "customerOnly".equals(mode) ? "active" : "" %>" id="customer-only-tab" data-bs-toggle="tab" data-bs-target="#customer-only-pane" type="button" role="tab" aria-controls="customer-only-pane" aria-selected="<%= "customerOnly".equals(mode) ? "true" : "false" %>">Customer Only</button>
            </li>
        </ul>

        <div class="tab-content pt-3" id="billReportTabsContent">
            <div class="tab-pane fade <%= "dateCustomer".equals(mode) ? "show active" : "" %>" id="date-customer-pane" role="tabpanel" aria-labelledby="date-customer-tab" tabindex="0">
                <form method="get" class="row g-2 align-items-end">
                    <input type="hidden" name="mode" value="dateCustomer">
                    <div class="col-md-3 col-sm-6 input-outline">
                        <input type="date" id="fromDate" name="fromDate" class="form-control" value="<%= fromDate %>">
                        <label>From Bill Date</label>
                    </div>
                    <div class="col-md-3 col-sm-6 input-outline">
                        <input type="date" id="toDate" name="toDate" class="form-control" value="<%= toDate %>">
                        <label>To Bill Date</label>
                    </div>
                    <div class="col-md-4 col-sm-12 input-outline">
                        <input type="text" id="customerName" name="customerName" class="form-control" value="<%= customerName %>" placeholder=" ">
                        <label>Customer Name</label>
                    </div>
                    <div class="col-md-2 col-sm-12">
                        <button class="btn btn-primary w-100" style="height:38px;">Run Report</button>
                    </div>
                </form>
            </div>

            <div class="tab-pane fade <%= "customerOnly".equals(mode) ? "show active" : "" %>" id="customer-only-pane" role="tabpanel" aria-labelledby="customer-only-tab" tabindex="0">
                <form method="get" class="row g-2 align-items-end">
                    <input type="hidden" name="mode" value="customerOnly">
                    <div class="col-md-3 col-sm-6 input-outline">
                        <select id="searchBy" name="searchBy" class="form-select">
                            <option value="name" <%= "name".equalsIgnoreCase(searchBy) ? "selected" : "" %>>Customer Name</option>
                            <option value="phone" <%= "phone".equalsIgnoreCase(searchBy) ? "selected" : "" %>>Phone Number</option>
                        </select>
                        <label>Filter By</label>
                    </div>
                    <div class="col-md-7 col-sm-12 input-outline">
                        <input type="text" id="searchText" name="searchText" class="form-control" value="<%= searchText %>" placeholder=" ">
                        <label>Customer (All Bills, No Date Filter)</label>
                    </div>
                    <div class="col-md-2 col-sm-12">
                        <button class="btn btn-success w-100" style="height:38px;">Run Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="gbr-card">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="gbr-title mb-0"><i class="fa-solid fa-list me-2"></i>Bill Entries</div>
            <a href="<%= csvHref %>" class="btn btn-sm btn-outline-primary">
                <i class="fa-solid fa-file-csv me-1"></i>Download CSV
            </a>
        </div>
        <div style="overflow:auto;">
            <table class="gbr-table">
                <thead>
                    <tr>
                        <th>Bill No</th>
                        <th>Bill Date</th>
                        <th>Bill Time</th>
                        <th>Cust ID</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Gold Rate</th>
                        <th>Gross</th>
                        <th>Margin</th>
                        <th>Net</th>
                        <th>Release</th>
                        <th>Amount Paid</th>
                        <th>User</th>
                        <th>Print</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (rows == null || rows.size() == 0) {
                %>
                    <tr>
                        <td colspan="14" class="muted" style="text-align:center; padding:18px;">No bills found for selected filters.</td>
                    </tr>
                <%
                    } else {
                        for (int i = 0; i < rows.size(); i++) {
                            Vector r = (Vector) rows.get(i);
                %>
                    <tr>
                        <td><%= r.get(1) %></td>
                        <td><%= r.get(2) %></td>
                        <td><%= r.get(3) %></td>
                        <td><%= r.get(4) == null ? "" : r.get(4) %></td>
                        <td><%= r.get(5) %></td>
                        <td><%= r.get(6) == null ? "" : r.get(6) %></td>
                        <td class="num"><%= r.get(7) %></td>
                        <td class="num"><%= r.get(8) %></td>
                        <td class="num"><%= r.get(9) %></td>
                        <td class="num"><%= r.get(10) %></td>
                        <td class="num"><%= r.get(11) %></td>
                        <td class="num"><%= r.get(12) %></td>
                        <td><%= r.get(13) %></td>
                        <td style="text-align:center;">
                            <a href="<%= request.getContextPath() %>/gold/goldBill/print.jsp?id=<%= r.get(0) %>" target="_blank" class="btn btn-sm btn-outline-primary">Print</a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                <tr class="total-row">
                    <td colspan="7" class="num">TOTAL</td>
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
