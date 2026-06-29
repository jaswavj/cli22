<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    response.setHeader("Cache-Control","no-cache");
    out.clearBuffer();

    org.json.JSONObject resp = new org.json.JSONObject();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        int customerId = 0;
        try { customerId = Integer.parseInt(request.getParameter("customerId")); } catch (Exception e) {}

        if (customerId <= 0) {
            resp.put("status", "error");
            resp.put("msg", "Invalid customer id");
        } else {
            con = util.DBConnectionManager.getConnectionFromPool();
            ps = con.prepareStatement(
                "SELECT COUNT(*) AS bill_count FROM gold_bill WHERE customer_id = ? AND is_cancelled = 0");
            ps.setInt(1, customerId);
            rs = ps.executeQuery();
            int billCount = 0;
            if (rs.next()) {
                billCount = rs.getInt("bill_count");
            }
            resp.put("status", "ok");
            resp.put("bill_count", billCount);
        }
    } catch (Exception e) {
        resp.put("status", "error");
        resp.put("msg", e.getMessage() != null ? e.getMessage() : "Server error");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
    out.print(resp.toString());
%>
