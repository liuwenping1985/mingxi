//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.v3x.services.util;

import com.seeyon.oainterface.util.XMLMakerUtils;
import com.seeyon.v3x.services.form.bean.DefinitionExport;
import com.seeyon.v3x.services.form.bean.FormExport;
import com.seeyon.v3x.services.form.bean.SubordinateFormExport;
import java.io.IOException;
import java.io.Serializable;
import java.io.Writer;
import java.util.Iterator;
import java.util.List;

public class SaveFormToXml implements Serializable {
    private static final String FormExport = "formExport";
    private static final String SUMMARY = "summary";
    private static final String VALUES = "values";
    private static final String VALUE = "value";
    private static final String COLUMN = "column";
    private static final String SUBFORMS = "subForms";
    private static final String SUBFORM = "subForm";
    private static final String VERSION = "2.0";
    private static final String C_sLN = "\r\n";
    private static final SaveFormToXml INSTANCE = new SaveFormToXml();

    public SaveFormToXml() {
    }

    public static final SaveFormToXml getInstance() {
        return INSTANCE;
    }

    public void saveXMLToStream(Writer aWriter, FormExport export) throws IOException {
        this.saveXMLToStream_space(aWriter, 0, export);
    }

    private void saveXMLToStream_space(Writer aWriter, int aSpace, FormExport export) throws IOException {
        aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("formExport", aSpace, new String[]{"version", "2.0"}));
        aWriter.write(XMLMakerUtils.getXMLNodeSingleLn("summary", aSpace + 2, new String[]{"id", "-1", "name", "" + export.getFormName()}));
        aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("values", aSpace, new String[0]));
        List<DefinitionExport> mainFileList = export.getDefinitions();
        Iterator var5 = mainFileList.iterator();

        while(var5.hasNext()) {
            DefinitionExport mainFile = (DefinitionExport)var5.next();
            aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("column", aSpace + 2, new String[]{"name", "" + mainFile.getDisplayName()}));
            aWriter.write(XMLMakerUtils.getXMLNodeSingleLn("value", aSpace, new String[0]));
            aWriter.write(XMLMakerUtils.getXMLNodeEndLn("column", aSpace));
        }

        aWriter.write(XMLMakerUtils.getXMLNodeEndLn("values", aSpace - 2));
        aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("subForms", aSpace, new String[0]));
        var5 = export.getSubordinateForms().iterator();

        while(var5.hasNext()) {
            SubordinateFormExport s = (SubordinateFormExport)var5.next();
            aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("subForm", aSpace + 2, new String[0]));
            aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("values", aSpace, new String[0]));
            List<DefinitionExport> subFileList = s.getDefinitions();
            Iterator var8 = subFileList.iterator();

            while(var8.hasNext()) {
                DefinitionExport subFile = (DefinitionExport)var8.next();
                aWriter.write(XMLMakerUtils.getXMLNodeHeadLn("column", aSpace + 2, new String[]{"name", "" + subFile.getDisplayName()}));
                aWriter.write(XMLMakerUtils.getXMLNodeSingleLn("value", aSpace, new String[0]));
                aWriter.write(XMLMakerUtils.getXMLNodeEndLn("column", aSpace));
            }

            aWriter.write(XMLMakerUtils.getXMLNodeEndLn("values", aSpace - 2));
            aWriter.write(XMLMakerUtils.getXMLNodeEndLn("subForm", aSpace));
        }

        aWriter.write(XMLMakerUtils.getXMLNodeEndLn("subForms", aSpace - 2));
        aWriter.write(XMLMakerUtils.getXMLNodeEndLn("formExport", aSpace));
        aWriter.flush();
    }
}
