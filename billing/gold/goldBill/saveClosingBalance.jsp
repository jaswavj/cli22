<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="org.json.JSONObject" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    JSONObject resp = new JSONObject();

    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        resp.put("status", "error");
        resp.put("message", "User not logged in");
        out.print(resp.toString());
        return;
    }

    String balanceParam = request.getParameter("balance");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        double balance = Double.parseDouble(balanceParam);

        String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        String currentTime = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date());

        InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/golddb");
        con = ds.getConnection();
        con.setAutoCommit(false);

        ps = con.prepareStatement(
            "INSERT INTO gold_ledger " +
            "(customer_id, customer_name, bill_id, txn_type, opening_balance, amount, closing_balance, " +
            " description, txn_date, txn_time, entered_by, entered_dt) " +
            "VALUES (NULL, 'CLOSING BALANCE', NULL, 'PAYMENT', 0, ?, 0, 'Closing Balance', ?, ?, ?, NOW())"
        );
        ps.setDouble(1, balance);
        ps.setString(2, today);
        ps.setString(3, currentTime);
        ps.setInt(4, userId);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            con.commit();
            resp.put("status", "ok");
            resp.put("message", "Closing balance saved successfully");
        } else {
            con.rollback();
            resp.put("status", "error");
            resp.put("message", "Failed to save closing balance");
        }

    } catch (NumberFormatException e) {
        if (con != null) try { con.rollback(); } catch (Exception ex) {}
        resp.put("status", "error");
        resp.put("message", "Invalid balance amount");
    } catch (Exception e) {
        if (con != null) try { con.rollback(); } catch (Exception ex) {}
        resp.put("status", "error");
        resp.put("message", e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }

    out.print(resp.toString());
%>
