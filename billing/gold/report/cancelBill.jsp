<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject" %>
<jsp:useBean id="goldBean" class="gold.goldBillingBean" />
<%
    response.setContentType("application/json; charset=UTF-8");
    response.setHeader("Cache-Control", "no-cache");
    out.clearBuffer();

    JSONObject resp = new JSONObject();
    try {
        Integer uid = (Integer) session.getAttribute("userId");
        if (uid == null) {
            resp.put("status", "error");
            resp.put("msg", "Session expired. Please login again.");
            out.print(resp.toString());
            return;
        }

        int billId = 0;
        try { billId = Integer.parseInt(request.getParameter("billId")); } catch (Exception e) {}

        if (billId <= 0) {
            resp.put("status", "error");
            resp.put("msg", "Invalid bill id.");
            out.print(resp.toString());
            return;
        }

        if (goldBean.cancelBill(billId, uid.intValue())) {
            resp.put("status", "ok");
            resp.put("msg", "Bill cancelled successfully. Ledger has been adjusted.");
        } else {
            resp.put("status", "error");
            resp.put("msg", "Bill not found or already cancelled.");
        }
    } catch (Exception e) {
        resp.put("status", "error");
        resp.put("msg", e.getMessage() != null ? e.getMessage() : "Cancel failed.");
    }
    out.print(resp.toString());
%>
