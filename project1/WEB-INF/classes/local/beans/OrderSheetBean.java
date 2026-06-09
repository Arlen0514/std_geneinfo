/**
 * OrderSheetBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'order_sheet'.
 */
public final class OrderSheetBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "order_sheet";

    // Fields variable definition.
    private String os_id             = "";
    private String os_no             = "";
    private String os_status         = "";
    private String os_name           = "";
    private String os_sex            = "";
    private String os_company        = "";
    private String os_dep            = "";
    private String os_post           = "";
    private String os_fax            = "";
    private String os_phone          = "";
    private String os_cellphone      = "";
    private String os_email          = "";
    private String os_county         = "";
    private String os_city           = "";
    private String os_zipcode        = "";
    private String os_address        = "";
    private String os_contact        = "";
    private String os_info           = "";
    private String os_shop_time      = "";
    private String os_budget         = "";
    private String os_memo           = "";
    private String os_paymethod      = "";
    private String os_logistics      = "";
    private int    os_freight        = 0;
    private int    os_getbonus       = 0;
    private int    os_use_maxbonus   = 0;
    private int    os_usebonus       = 0;
    private String os_bonus_status   = "";
    private int    os_discount       = 0;
    private int    os_total          = 0;
    private String mp_id             = "";
    private String os_logistics_time = "";
    private String os_ship           = "";
    private String os_collect        = "";
    private String os_code           = "";
    private String os_lang           = "";
    private String os_createdate     = "";
    private String os_createuser     = "";
    private String os_modifydate     = "";
    private String os_modifyuser     = "";

    // Default constructor.
    public OrderSheetBean() {}

    // Setters definitions
    public void setOs_id(String os_id) {
        this.os_id = os_id;
    }

    public void setOs_no(String os_no) {
        this.os_no = os_no;
    }

    public void setOs_status(String os_status) {
        this.os_status = os_status;
    }

    public void setOs_name(String os_name) {
        this.os_name = os_name;
    }

    public void setOs_sex(String os_sex) {
        this.os_sex = os_sex;
    }

    public void setOs_company(String os_company) {
        this.os_company = os_company;
    }

    public void setOs_dep(String os_dep) {
        this.os_dep = os_dep;
    }

    public void setOs_post(String os_post) {
        this.os_post = os_post;
    }

    public void setOs_fax(String os_fax) {
        this.os_fax = os_fax;
    }

    public void setOs_phone(String os_phone) {
        this.os_phone = os_phone;
    }

    public void setOs_cellphone(String os_cellphone) {
        this.os_cellphone = os_cellphone;
    }

    public void setOs_email(String os_email) {
        this.os_email = os_email;
    }

    public void setOs_county(String os_county) {
        this.os_county = os_county;
    }

    public void setOs_city(String os_city) {
        this.os_city = os_city;
    }

    public void setOs_zipcode(String os_zipcode) {
        this.os_zipcode = os_zipcode;
    }

    public void setOs_address(String os_address) {
        this.os_address = os_address;
    }

    public void setOs_contact(String os_contact) {
        this.os_contact = os_contact;
    }

    public void setOs_info(String os_info) {
        this.os_info = os_info;
    }

    public void setOs_shop_time(String os_shop_time) {
        this.os_shop_time = os_shop_time;
    }

    public void setOs_budget(String os_budget) {
        this.os_budget = os_budget;
    }

    public void setOs_memo(String os_memo) {
        this.os_memo = os_memo;
    }

    public void setOs_paymethod(String os_paymethod) {
        this.os_paymethod = os_paymethod;
    }

    public void setOs_logistics(String os_logistics) {
        this.os_logistics = os_logistics;
    }

    public void setOs_freight(int os_freight) {
        this.os_freight = os_freight;
    }

    public void setOs_getbonus(int os_getbonus) {
        this.os_getbonus = os_getbonus;
    }

    public void setOs_use_maxbonus(int os_use_maxbonus) {
        this.os_use_maxbonus = os_use_maxbonus;
    }

    public void setOs_usebonus(int os_usebonus) {
        this.os_usebonus = os_usebonus;
    }

    public void setOs_bonus_status(String os_bonus_status) {
        this.os_bonus_status = os_bonus_status;
    }

    public void setOs_discount(int os_discount) {
        this.os_discount = os_discount;
    }

    public void setOs_total(int os_total) {
        this.os_total = os_total;
    }

    public void setMp_id(String mp_id) {
        this.mp_id = mp_id;
    }

    public void setOs_logistics_time(String os_logistics_time) {
        this.os_logistics_time = os_logistics_time;
    }

    public void setOs_ship(String os_ship) {
        this.os_ship = os_ship;
    }

    public void setOs_collect(String os_collect) {
        this.os_collect = os_collect;
    }

    public void setOs_code(String os_code) {
        this.os_code = os_code;
    }

    public void setOs_lang(String os_lang) {
        this.os_lang = os_lang;
    }

    public void setOs_createdate(String os_createdate) {
        this.os_createdate = os_createdate;
    }

    public void setOs_createuser(String os_createuser) {
        this.os_createuser = os_createuser;
    }

    public void setOs_modifydate(String os_modifydate) {
        this.os_modifydate = os_modifydate;
    }

    public void setOs_modifyuser(String os_modifyuser) {
        this.os_modifyuser = os_modifyuser;
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
        vc.add(os_id);
        vc.add(os_no);
        vc.add(os_status);
        vc.add(os_name);
        vc.add(os_sex);
        vc.add(os_company);
        vc.add(os_dep);
        vc.add(os_post);
        vc.add(os_fax);
        vc.add(os_phone);
        vc.add(os_cellphone);
        vc.add(os_email);
        vc.add(os_county);
        vc.add(os_city);
        vc.add(os_zipcode);
        vc.add(os_address);
        vc.add(os_contact);
        vc.add(os_info);
        vc.add(os_shop_time);
        vc.add(os_budget);
        vc.add(os_memo);
        vc.add(os_paymethod);
        vc.add(os_logistics);
        vc.add(new Integer(os_freight));
        vc.add(new Integer(os_getbonus));
        vc.add(new Integer(os_use_maxbonus));
        vc.add(new Integer(os_usebonus));
        vc.add(os_bonus_status);
        vc.add(new Integer(os_discount));
        vc.add(new Integer(os_total));
        vc.add(mp_id);
        vc.add(os_logistics_time);
        vc.add(os_ship);
        vc.add(os_collect);
        vc.add(os_code);
        vc.add(os_lang);
        vc.add(os_createdate);
        vc.add(os_createuser);
        vc.add(os_modifydate);
        vc.add(os_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getOs_id() {
        return os_id;
    }

    public String getOs_no() {
        return os_no;
    }

    public String getOs_status() {
        return os_status;
    }

    public String getOs_name() {
        return os_name;
    }

    public String getOs_sex() {
        return os_sex;
    }

    public String getOs_company() {
        return os_company;
    }

    public String getOs_dep() {
        return os_dep;
    }

    public String getOs_post() {
        return os_post;
    }

    public String getOs_fax() {
        return os_fax;
    }

    public String getOs_phone() {
        return os_phone;
    }

    public String getOs_cellphone() {
        return os_cellphone;
    }

    public String getOs_email() {
        return os_email;
    }

    public String getOs_county() {
        return os_county;
    }

    public String getOs_city() {
        return os_city;
    }

    public String getOs_zipcode() {
        return os_zipcode;
    }

    public String getOs_address() {
        return os_address;
    }

    public String getOs_contact() {
        return os_contact;
    }

    public String getOs_info() {
        return os_info;
    }

    public String getOs_shop_time() {
        return os_shop_time;
    }

    public String getOs_budget() {
        return os_budget;
    }

    public String getOs_memo() {
        return os_memo;
    }

    public String getOs_paymethod() {
        return os_paymethod;
    }

    public String getOs_logistics() {
        return os_logistics;
    }

    public int getOs_freight() {
        return os_freight;
    }

    public int getOs_getbonus() {
        return os_getbonus;
    }

    public int getOs_use_maxbonus() {
        return os_use_maxbonus;
    }

    public int getOs_usebonus() {
        return os_usebonus;
    }

    public String getOs_bonus_status() {
        return os_bonus_status;
    }

    public int getOs_discount() {
        return os_discount;
    }

    public int getOs_total() {
        return os_total;
    }

    public String getMp_id() {
        return mp_id;
    }

    public String getOs_logistics_time() {
        return os_logistics_time;
    }

    public String getOs_ship() {
        return os_ship;
    }

    public String getOs_collect() {
        return os_collect;
    }

    public String getOs_code() {
        return os_code;
    }

    public String getOs_lang() {
        return os_lang;
    }

    public String getOs_createdate() {
        return os_createdate;
    }

    public String getOs_createuser() {
        return os_createuser;
    }

    public String getOs_modifydate() {
        return os_modifydate;
    }

    public String getOs_modifyuser() {
        return os_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "os_id", "os_no", "os_status", "os_name", 
        "os_sex", "os_company", "os_dep", "os_post", 
        "os_fax", "os_phone", "os_cellphone", "os_email", 
        "os_county", "os_city", "os_zipcode", "os_address", 
        "os_contact", "os_info", "os_shop_time", "os_budget", 
        "os_memo", "os_paymethod", "os_logistics", "os_freight", 
        "os_getbonus", "os_use_maxbonus", "os_usebonus", "os_bonus_status", 
        "os_discount", "os_total", "mp_id", "os_logistics_time", 
        "os_ship", "os_collect", "os_code", "os_lang", 
        "os_createdate", "os_createuser", "os_modifydate", "os_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "int", "int", "int", "int", "String", 
        "int", "int", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String" };
}
