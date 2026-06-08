/**
 * OrderListBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'order_list'.
 */
public final class OrderListBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "order_list";

    // Fields variable definition.
    private String ol_id                = "";
    private String os_id                = "";
    private String pd_id                = "";
    private String pd_no                = "";
    private String pd_name              = "";
    private int    pd_price             = 0;
    private String ps_id                = "";
    private String ps_type              = "";
    private int    pd_quantity          = 0;
    private String pd_preorder          = "";
    private String ol_logistics_company = "";
    private String ol_shipper_number    = "";
    private String ol_shipper_date      = "";
    private String ol_code              = "";
    private String ol_status            = "";
    private String ol_createdate        = "";
    private String ol_createuser        = "";
    private String ol_modifydate        = "";
    private String ol_modifyuser        = "";

    // Default constructor.
    public OrderListBean() {}

    // Setters definitions
    public void setOl_id(String ol_id) {
        this.ol_id = ol_id;
    }

    public void setOs_id(String os_id) {
        this.os_id = os_id;
    }

    public void setPd_id(String pd_id) {
        this.pd_id = pd_id;
    }

    public void setPd_no(String pd_no) {
        this.pd_no = pd_no;
    }

    public void setPd_name(String pd_name) {
        this.pd_name = pd_name;
    }

    public void setPd_price(int pd_price) {
        this.pd_price = pd_price;
    }

    public void setPs_id(String ps_id) {
        this.ps_id = ps_id;
    }

    public void setPs_type(String ps_type) {
        this.ps_type = ps_type;
    }

    public void setPd_quantity(int pd_quantity) {
        this.pd_quantity = pd_quantity;
    }

    public void setPd_preorder(String pd_preorder) {
        this.pd_preorder = pd_preorder;
    }

    public void setOl_logistics_company(String ol_logistics_company) {
        this.ol_logistics_company = ol_logistics_company;
    }

    public void setOl_shipper_number(String ol_shipper_number) {
        this.ol_shipper_number = ol_shipper_number;
    }

    public void setOl_shipper_date(String ol_shipper_date) {
        this.ol_shipper_date = ol_shipper_date;
    }

    public void setOl_code(String ol_code) {
        this.ol_code = ol_code;
    }

    public void setOl_status(String ol_status) {
        this.ol_status = ol_status;
    }

    public void setOl_createdate(String ol_createdate) {
        this.ol_createdate = ol_createdate;
    }

    public void setOl_createuser(String ol_createuser) {
        this.ol_createuser = ol_createuser;
    }

    public void setOl_modifydate(String ol_modifydate) {
        this.ol_modifydate = ol_modifydate;
    }

    public void setOl_modifyuser(String ol_modifyuser) {
        this.ol_modifyuser = ol_modifyuser;
    }

    // Convert the fields name, type, value into a Vector.
    public Vector beanContent() {
        Vector content = new Vector();
        // Field names.
        content.add(_fnames);
        // Field java types.
        content.add(_ftypes);
        // Field values.
        Vector vc = new Vector();
        vc.add(ol_id);
        vc.add(os_id);
        vc.add(pd_id);
        vc.add(pd_no);
        vc.add(pd_name);
        vc.add(new Integer(pd_price));
        vc.add(ps_id);
        vc.add(ps_type);
        vc.add(new Integer(pd_quantity));
        vc.add(pd_preorder);
        vc.add(ol_logistics_company);
        vc.add(ol_shipper_number);
        vc.add(ol_shipper_date);
        vc.add(ol_code);
        vc.add(ol_status);
        vc.add(ol_createdate);
        vc.add(ol_createuser);
        vc.add(ol_modifydate);
        vc.add(ol_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getOl_id() {
        return ol_id;
    }

    public String getOs_id() {
        return os_id;
    }

    public String getPd_id() {
        return pd_id;
    }

    public String getPd_no() {
        return pd_no;
    }

    public String getPd_name() {
        return pd_name;
    }

    public int getPd_price() {
        return pd_price;
    }

    public String getPs_id() {
        return ps_id;
    }

    public String getPs_type() {
        return ps_type;
    }

    public int getPd_quantity() {
        return pd_quantity;
    }

    public String getPd_preorder() {
        return pd_preorder;
    }

    public String getOl_logistics_company() {
        return ol_logistics_company;
    }

    public String getOl_shipper_number() {
        return ol_shipper_number;
    }

    public String getOl_shipper_date() {
        return ol_shipper_date;
    }

    public String getOl_code() {
        return ol_code;
    }

    public String getOl_status() {
        return ol_status;
    }

    public String getOl_createdate() {
        return ol_createdate;
    }

    public String getOl_createuser() {
        return ol_createuser;
    }

    public String getOl_modifydate() {
        return ol_modifydate;
    }

    public String getOl_modifyuser() {
        return ol_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "ol_id", "os_id", "pd_id", "pd_no", 
        "pd_name", "pd_price", "ps_id", "ps_type", 
        "pd_quantity", "pd_preorder", "ol_logistics_company", "ol_shipper_number", 
        "ol_shipper_date", "ol_code", "ol_status", "ol_createdate", 
        "ol_createuser", "ol_modifydate", "ol_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "int", "String", 
        "String", "int", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
