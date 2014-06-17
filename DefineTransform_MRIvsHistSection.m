function [tfm_MRI2Hist,tfm_Hist2MRI] = DefineTransform_MRIvsHistSection(tfm_MRtoHistSum, tfm_HistRefSection2HistSum, tfm_DestSection2RefSection)

tfm_MRI2Hist = maketform('composite',tfm_MRtoHistSum, fliptform(tfm_HistRefSection2HistSum), tfm_DestSection2RefSection);
tfm_Hist2MRI = fliptform(tfm_MRI2Hist);
