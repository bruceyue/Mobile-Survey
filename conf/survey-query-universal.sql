select 
	name, 
	sfid, 
	survey_type__c, 
	grading_scale__c 
from 
	dms_survey__c s
where
	universal_survey__c
	and survey_type__c != ''Non Product'' 
	and	(Active__c is null or Active__c = true) 
	and	(IsParent__c is null or IsParent__c = false) 
	and parent_survey__c is null 
	and (
		universal_survey__c 
		or sfid in (
            SELECT
                DISTINCT dd_survey__c
            FROM
                dd_survey_member__c
            WHERE
                dd_survey_group__c IN (
                    SELECT
                        sm.dd_survey_group__c
                    FROM
                        dd_group_member__c gm
                        INNER JOIN dd_survey_member__c sm ON sm.dd_survey_group__c = gm.dd_survey_group__c
                    WHERE
                        gm.contact__c = ''{0}''
                ) 
		) or (
			SELECT
				count(*)
			FROM
				dd_survey_member__c
			WHERE
				dd_survey__c = s.sfid
		) = 0
	)
order by 
	sfid