/**
 * FacultyRelatedBean.java
 * Created by com.genesis.util.BeanCreator
 *         on 2024/02/05 09:59:02
 * @author Kevin Koo
 */
package local.beans;

import com.genesis.sql.*;

import java.util.*;

/**
 * JavaBean class for database table 'faculty_related'.
 */
public final class FacultyRelatedBean implements java.io.Serializable {

    // Table name.
    private String _tableName = "faculty_related";

    // Fields variable definition.
    private String fr_id         = "";
    private String fp_id         = "";
    private String fr_year       = "";
    private String fr_no         = "";
    private String fr_title      = "";
    private String fr_type       = "";
    private String fr_person     = "";
    private String fr_job        = "";
    private String fr_agency     = "";
    private String fr_country    = "";
    private String fr_school     = "";
    private String fr_department = "";
    private String fr_degree     = "";
    private String fr_content    = "";
    private String fr_startdate  = "";
    private String fr_enddate    = "";
    private String fr_emitdate   = "";
    private String fr_restdate   = "";
    private int    fr_showseq    = 0;
    private String fr_lang       = "";
    private String fr_code       = "";
    private String fr_createdate = "";
    private String fr_createuser = "";
    private String fr_modifydate = "";
    private String fr_modifyuser = "";

    // Default constructor.
    public FacultyRelatedBean() {}

    // Setters definitions
    public void setFr_id(String fr_id) {
        this.fr_id = fr_id;
    }

    public void setFp_id(String fp_id) {
        this.fp_id = fp_id;
    }

    public void setFr_year(String fr_year) {
        this.fr_year = fr_year;
    }

    public void setFr_no(String fr_no) {
        this.fr_no = fr_no;
    }

    public void setFr_title(String fr_title) {
        this.fr_title = fr_title;
    }

    public void setFr_type(String fr_type) {
        this.fr_type = fr_type;
    }

    public void setFr_person(String fr_person) {
        this.fr_person = fr_person;
    }

    public void setFr_job(String fr_job) {
        this.fr_job = fr_job;
    }

    public void setFr_agency(String fr_agency) {
        this.fr_agency = fr_agency;
    }

    public void setFr_country(String fr_country) {
        this.fr_country = fr_country;
    }

    public void setFr_school(String fr_school) {
        this.fr_school = fr_school;
    }

    public void setFr_department(String fr_department) {
        this.fr_department = fr_department;
    }

    public void setFr_degree(String fr_degree) {
        this.fr_degree = fr_degree;
    }

    public void setFr_content(String fr_content) {
        this.fr_content = fr_content;
    }

    public void setFr_startdate(String fr_startdate) {
        this.fr_startdate = fr_startdate;
    }

    public void setFr_enddate(String fr_enddate) {
        this.fr_enddate = fr_enddate;
    }

    public void setFr_emitdate(String fr_emitdate) {
        this.fr_emitdate = fr_emitdate;
    }

    public void setFr_restdate(String fr_restdate) {
        this.fr_restdate = fr_restdate;
    }

    public void setFr_showseq(int fr_showseq) {
        this.fr_showseq = fr_showseq;
    }

    public void setFr_lang(String fr_lang) {
        this.fr_lang = fr_lang;
    }

    public void setFr_code(String fr_code) {
        this.fr_code = fr_code;
    }

    public void setFr_createdate(String fr_createdate) {
        this.fr_createdate = fr_createdate;
    }

    public void setFr_createuser(String fr_createuser) {
        this.fr_createuser = fr_createuser;
    }

    public void setFr_modifydate(String fr_modifydate) {
        this.fr_modifydate = fr_modifydate;
    }

    public void setFr_modifyuser(String fr_modifyuser) {
        this.fr_modifyuser = fr_modifyuser;
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
        vc.add(fr_id);
        vc.add(fp_id);
        vc.add(fr_year);
        vc.add(fr_no);
        vc.add(fr_title);
        vc.add(fr_type);
        vc.add(fr_person);
        vc.add(fr_job);
        vc.add(fr_agency);
        vc.add(fr_country);
        vc.add(fr_school);
        vc.add(fr_department);
        vc.add(fr_degree);
        vc.add(fr_content);
        vc.add(fr_startdate);
        vc.add(fr_enddate);
        vc.add(fr_emitdate);
        vc.add(fr_restdate);
        vc.add(new Integer(fr_showseq));
        vc.add(fr_lang);
        vc.add(fr_code);
        vc.add(fr_createdate);
        vc.add(fr_createuser);
        vc.add(fr_modifydate);
        vc.add(fr_modifyuser);
        content.add(vc);
        return content;
    }

    // Getters definitions
    public String getFr_id() {
        return fr_id;
    }

    public String getFp_id() {
        return fp_id;
    }

    public String getFr_year() {
        return fr_year;
    }

    public String getFr_no() {
        return fr_no;
    }

    public String getFr_title() {
        return fr_title;
    }

    public String getFr_type() {
        return fr_type;
    }

    public String getFr_person() {
        return fr_person;
    }

    public String getFr_job() {
        return fr_job;
    }

    public String getFr_agency() {
        return fr_agency;
    }

    public String getFr_country() {
        return fr_country;
    }

    public String getFr_school() {
        return fr_school;
    }

    public String getFr_department() {
        return fr_department;
    }

    public String getFr_degree() {
        return fr_degree;
    }

    public String getFr_content() {
        return fr_content;
    }

    public String getFr_startdate() {
        return fr_startdate;
    }

    public String getFr_enddate() {
        return fr_enddate;
    }

    public String getFr_emitdate() {
        return fr_emitdate;
    }

    public String getFr_restdate() {
        return fr_restdate;
    }

    public int getFr_showseq() {
        return fr_showseq;
    }

    public String getFr_lang() {
        return fr_lang;
    }

    public String getFr_code() {
        return fr_code;
    }

    public String getFr_createdate() {
        return fr_createdate;
    }

    public String getFr_createuser() {
        return fr_createuser;
    }

    public String getFr_modifydate() {
        return fr_modifydate;
    }

    public String getFr_modifyuser() {
        return fr_modifyuser;
    }

    // Get the table's name.
    public String tableName() {
        return _tableName;
    }

    // The field names.
    private String[] _fnames = new String[] {
        "fr_id", "fp_id", "fr_year", "fr_no", 
        "fr_title", "fr_type", "fr_person", "fr_job", 
        "fr_agency", "fr_country", "fr_school", "fr_department", 
        "fr_degree", "fr_content", "fr_startdate", "fr_enddate", 
        "fr_emitdate", "fr_restdate", "fr_showseq", "fr_lang", 
        "fr_code", "fr_createdate", "fr_createuser", "fr_modifydate", 
        "fr_modifyuser" };

    // The field java types.
    private String[] _ftypes = new String[] {
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "String", "String", "String", 
        "String", "String", "String", "String", "int", "String", "String", 
        "String", "String", "String", "String" };
}
