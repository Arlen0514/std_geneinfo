/**
 * ProductDetailBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'product_detail'.
 */
public final class ProductDetailBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "product_detail";

    // Fields variable definition.
    private String pd_id             = "";
    private String pd_no             = "";
    private String pd_upcategory     = "";
    private String pd_category       = "";
    private String pd_title          = "";
    private String pd_desc           = "";
    private String pd_spec           = "";
    private String pd_content        = "";
    private String pd_image          = "";
    private String pd_mobile         = "";
    private String pd_file           = "";
    private String pd_alt            = "";
    private String pd_url            = "";
    private String pd_target         = "";
    private String pd_display        = "";
    private String pd_hot            = "";
    private String pd_new            = "";
    private int    pd_showseq        = 0;
    private String pd_emitdate       = "";
    private String pd_restdate       = "";
    private String pd_lang           = "";
    private String pd_code           = "";
    private String pd_webtitle       = "";
    private String pd_robots         = "";
    private String pd_revisit_after  = "";
    private String pd_keywords       = "";
    private String pd_description    = "";
    private String pd_copyright      = "";
    private String pd_seo_head_track = "";
    private String pd_seo_body_track = "";
    private String pd_createdate     = "";
    private String pd_createuser     = "";
    private String pd_modifydate     = "";
    private String pd_modifyuser     = "";

    // Default constructor.
    public ProductDetailBean() {}

    // Setters definitions
    public void setPd_id(String pd_id) {
        this.pd_id = pd_id;
    }

    public void setPd_no(String pd_no) {
        this.pd_no = pd_no;
    }

    public void setPd_upcategory(String pd_upcategory) {
        this.pd_upcategory = pd_upcategory;
    }

    public void setPd_category(String pd_category) {
        this.pd_category = pd_category;
    }

    public void setPd_title(String pd_title) {
        this.pd_title = pd_title;
    }

    public void setPd_desc(String pd_desc) {
        this.pd_desc = pd_desc;
    }

    public void setPd_spec(String pd_spec) {
        this.pd_spec = pd_spec;
    }

    public void setPd_content(String pd_content) {
        this.pd_content = pd_content;
    }

    public void setPd_image(String pd_image) {
        this.pd_image = pd_image;
    }

    public void setPd_mobile(String pd_mobile) {
        this.pd_mobile = pd_mobile;
    }

    public void setPd_file(String pd_file) {
        this.pd_file = pd_file;
    }

    public void setPd_alt(String pd_alt) {
        this.pd_alt = pd_alt;
    }

    public void setPd_url(String pd_url) {
        this.pd_url = pd_url;
    }

    public void setPd_target(String pd_target) {
        this.pd_target = pd_target;
    }

    public void setPd_display(String pd_display) {
        this.pd_display = pd_display;
    }

    public void setPd_hot(String pd_hot) {
        this.pd_hot = pd_hot;
    }

    public void setPd_new(String pd_new) {
        this.pd_new = pd_new;
    }

    public void setPd_showseq(int pd_showseq) {
        this.pd_showseq = pd_showseq;
    }

    public void setPd_emitdate(String pd_emitdate) {
        this.pd_emitdate = pd_emitdate;
    }

    public void setPd_restdate(String pd_restdate) {
        this.pd_restdate = pd_restdate;
    }

    public void setPd_lang(String pd_lang) {
        this.pd_lang = pd_lang;
    }

    public void setPd_code(String pd_code) {
        this.pd_code = pd_code;
    }

    public void setPd_webtitle(String pd_webtitle) {
        this.pd_webtitle = pd_webtitle;
    }

    public void setPd_robots(String pd_robots) {
        this.pd_robots = pd_robots;
    }

    public void setPd_revisit_after(String pd_revisit_after) {
        this.pd_revisit_after = pd_revisit_after;
    }

    public void setPd_keywords(String pd_keywords) {
        this.pd_keywords = pd_keywords;
    }

    public void setPd_description(String pd_description) {
        this.pd_description = pd_description;
    }

    public void setPd_copyright(String pd_copyright) {
        this.pd_copyright = pd_copyright;
    }

    public void setPd_seo_head_track(String pd_seo_head_track) {
        this.pd_seo_head_track = pd_seo_head_track;
    }

    public void setPd_seo_body_track(String pd_seo_body_track) {
        this.pd_seo_body_track = pd_seo_body_track;
    }

    public void setPd_createdate(String pd_createdate) {
        this.pd_createdate = pd_createdate;
    }

    public void setPd_createuser(String pd_createuser) {
        this.pd_createuser = pd_createuser;
    }

    public void setPd_modifydate(String pd_modifydate) {
        this.pd_modifydate = pd_modifydate;
    }

    public void setPd_modifyuser(String pd_modifyuser) {
        this.pd_modifyuser = pd_modifyuser;
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
        vc.add(pd_id);
        vc.add(pd_no);
        vc.add(pd_upcategory);
        vc.add(pd_category);
        vc.add(pd_title);
        vc.add(pd_desc);
        vc.add(pd_spec);
        vc.add(pd_content);
        vc.add(pd_image);
        vc.add(pd_mobile);
        vc.add(pd_file);
        vc.add(pd_alt);
        vc.add(pd_url);
        vc.add(pd_target);
        vc.add(pd_display);
        vc.add(pd_hot);
        vc.add(pd_new);
        vc.add(new Integer(pd_showseq));
        vc.add(pd_emitdate);
        vc.add(pd_restdate);
        vc.add(pd_lang);
        vc.add(pd_code);
        vc.add(pd_webtitle);
        vc.add(pd_robots);
        vc.add(pd_revisit_after);
        vc.add(pd_keywords);
        vc.add(pd_description);
        vc.add(pd_copyright);
        vc.add(pd_seo_head_track);
        vc.add(pd_seo_body_track);
        vc.add(pd_createdate);
        vc.add(pd_createuser);
        vc.add(pd_modifydate);
        vc.add(pd_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getPd_id() {
        return pd_id;
    }

    public String getPd_no() {
        return pd_no;
    }

    public String getPd_upcategory() {
        return pd_upcategory;
    }

    public String getPd_category() {
        return pd_category;
    }

    public String getPd_title() {
        return pd_title;
    }

    public String getPd_desc() {
        return pd_desc;
    }

    public String getPd_spec() {
        return pd_spec;
    }

    public String getPd_content() {
        return pd_content;
    }

    public String getPd_image() {
        return pd_image;
    }

    public String getPd_mobile() {
        return pd_mobile;
    }

    public String getPd_file() {
        return pd_file;
    }

    public String getPd_alt() {
        return pd_alt;
    }

    public String getPd_url() {
        return pd_url;
    }

    public String getPd_target() {
        return pd_target;
    }

    public String getPd_display() {
        return pd_display;
    }

    public String getPd_hot() {
        return pd_hot;
    }

    public String getPd_new() {
        return pd_new;
    }

    public int getPd_showseq() {
        return pd_showseq;
    }

    public String getPd_emitdate() {
        return pd_emitdate;
    }

    public String getPd_restdate() {
        return pd_restdate;
    }

    public String getPd_lang() {
        return pd_lang;
    }

    public String getPd_code() {
        return pd_code;
    }

    public String getPd_webtitle() {
        return pd_webtitle;
    }

    public String getPd_robots() {
        return pd_robots;
    }

    public String getPd_revisit_after() {
        return pd_revisit_after;
    }

    public String getPd_keywords() {
        return pd_keywords;
    }

    public String getPd_description() {
        return pd_description;
    }

    public String getPd_copyright() {
        return pd_copyright;
    }

    public String getPd_seo_head_track() {
        return pd_seo_head_track;
    }

    public String getPd_seo_body_track() {
        return pd_seo_body_track;
    }

    public String getPd_createdate() {
        return pd_createdate;
    }

    public String getPd_createuser() {
        return pd_createuser;
    }

    public String getPd_modifydate() {
        return pd_modifydate;
    }

    public String getPd_modifyuser() {
        return pd_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "pd_id", "pd_no", "pd_upcategory", "pd_category", 
        "pd_title", "pd_desc", "pd_spec", "pd_content", 
        "pd_image", "pd_mobile", "pd_file", "pd_alt", 
        "pd_url", "pd_target", "pd_display", "pd_hot", 
        "pd_new", "pd_showseq", "pd_emitdate", "pd_restdate", 
        "pd_lang", "pd_code", "pd_webtitle", "pd_robots", 
        "pd_revisit_after", "pd_keywords", "pd_description", "pd_copyright", 
        "pd_seo_head_track", "pd_seo_body_track", "pd_createdate", "pd_createuser", 
        "pd_modifydate", "pd_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "int", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String" };
}
