<cfcomponent>
<cffunction name="searchEmployees" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="searchStr" type="string" required="true" >
		<cfargument name="maxrows" type="numeric" default="25">
		<cfset var retVal = ArrayNew(1)>
		
		<cfquery username="WEBSCHEDULE_USER" password="1DOCMAU4WEBSCHEDULE2" datasource="inside2_docms" name="results">
			SELECT
				PS.EMPLID, PS.FIRST_NAME || ' ' || PS.LAST_NAME AS NAME, PS.FIRST_NAME || ' ' || PS.LAST_NAME  AS DISPLAYNAME,
				LOWER(PS.EMAIL_ADDRESS) AS EMAIL,
				PS.JOBCODE_DESCR AS JOBTITLE,
				PS.USERNAME,
				PS.DEPARTMENTNAME,
				PS.FULL_NAME,
				PS.WORKPHONE AS PHONE,
				PS.DEPARTMENTNAME,
				PS.DEPTID,
				PS.LOCATION
			FROM WEBSCHEDULE.ACTIVE_PEOPLESOFT PS
			WHERE 1=1

			<cfloop list="#lcase(arguments.searchStr)#" delimiters=" ," index="i">
				<cfif isNumeric(i)>
					AND PS.EMPLID like <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(i)#%" /> OR RFID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(i)#">
				<cfelse>
					AND lower(PS.FULL_NAME) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
				</cfif>
			</cfloop>
			
			ORDER BY PS.DEPARTMENTNAME, PS.LAST_NAME, PS.FIRST_NAME ASC
		</cfquery>

		<cfloop query="results">
			<cfset temp = {} />
			<cfset temp["total"] = RECORDCOUNT />
			<cfset temp["name"] = NAME />
			<cfset temp["username"] = USERNAME />
			<cfset temp["emplID"] = EMPLID />
			<cfset temp["departmentname"] = DEPARTMENTNAME />
			<cfset temp["orgcode"] = DEPTID />
			<cfset temp["displayName"] = DISPLAYNAME />
			<cfset temp["email"] = EMAIL />
			<cfset temp["jobTitle"] = JOBTITLE />
			<cfset temp["fullName"] = FULL_NAME />
			<cfset temp["phone"] = PHONE />
			<cfset temp["location"] = LOCATION />
			 <cfset ArrayAppend(retval, temp)>
		</cfloop>

		<cfset result = {} />
		<cfset result['items'] = retVal />
		<cfreturn result />
	</cffunction>

    <cffunction name="searchDepartment" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="searchStr" type="string" required="true" >
		<cfargument name="maxrows" type="numeric" default="25">
		<cfset var retVal = ArrayNew(1)>
		
		<cfquery username="WEBSCHEDULE_USER" password="1DOCMAU4WEBSCHEDULE2" datasource="inside2_docms" name="results">
			SELECT DISTINCT PS.DEPARTMENTNAME,PS.DEPTID,PS.LEV4_DEPT_NAME,PS.LEV4_DEPTID_DIVISIONLEVEL 
			FROM WEBSCHEDULE.DEPTMAPPING DM, WEBSCHEDULE.ACTIVE_PEOPLESOFT PS
			WHERE PS.DEPTID = DM.DEPTID
			<cfloop list="#lcase(arguments.searchStr)#" delimiters=" ," index="i">
				<cfif isNumeric(i)>
					AND PS.DEPTID like <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(i)#%" />
				<cfelse>
					AND lower(PS.DEPARTMENTNAME) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
				</cfif>
			</cfloop>
			GROUP By PS.DEPTID, PS.DEPARTMENTNAME, PS.LEV4_DEPT_NAME, PS.LEV4_DEPTID_DIVISIONLEVEL
			ORDER BY PS.LEV4_DEPT_NAME,PS.DEPARTMENTNAME
        </cfquery>

		<cfloop query="results">
			<cfset temp = {} />
			<cfset temp["divcode"] = LEV4_DEPTID_DIVISIONLEVEL />
			<cfset temp["divname"] = LEV4_DEPT_NAME />
			<cfset temp["orgcode"] = DEPTID />
			<cfset temp["orgname"] = DEPARTMENTNAME />
			 <cfset ArrayAppend(retval, temp)>
		</cfloop>

		<cfset result = {} />
		<cfset result['items'] = retVal />
		<cfreturn result />
	</cffunction>

    <cffunction name="getPool" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="poolID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT POOL_ID,POOL_NAME,DESCRIPTION FROM FELLOWS_LEDGER.Pool 
        <cfif len(arguments.poolID)>
            WHERE POOL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.poolID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["POOL_ID"] = POOL_ID />
                <cfset temp["POOL_NAME"] = POOL_NAME />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
    </cffunction>

<cffunction name="searchAccounts" access="remote" returntype="any" returnformat="JSON">
		<cfargument name="searchStr" type="string" required="true" >
		<cfargument name="maxrows" type="numeric" default="25">
		<cfset var retVal = ArrayNew(1)>
		
		<cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
			SELECT ACCOUNT, EFF_DATE,SHORT_DESC,SMALL_NAME,DESCRIPTION,ACCOUNT_OWNER,GL_ACCOUNT,ACCOUNT_TYPE,SETID,STATUS
            FROM FELLOWS_LEDGER.GENERAL_LEDGER_CHART_ACCOUNTS
            WHERE 1=1
			<cfloop list="#lcase(arguments.searchStr)#" delimiters=" ," index="i">
				<cfif isNumeric(i)>
					AND ACCOUNT like <cfqueryparam cfsqltype="cf_sql_varchar" value="#val(i)#%" />
				<cfelse>
					AND lower(SMALL_NAME) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%"> OR lower(SHORT_DESC) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
				</cfif>
			</cfloop>
			ORDER BY ACCOUNT, EFF_DATE ASC
		</cfquery>

		<cfloop query="results">
			<cfset temp = {} />
			<cfset temp["ACCOUNT"] = ACCOUNT />
            <cfset temp["EFF_DATE"] = EFF_DATE />
            <cfset temp["SHORT_DESC"] = SHORT_DESC />
            <cfset temp["SMALL_NAME"] = SMALL_NAME />
            <cfset temp["DESCRIPTION"] = DESCRIPTION />
            <cfset temp["ACCOUNT_OWNER"] = ACCOUNT_OWNER />
            <cfset temp["GL_ACCOUNT"] = GL_ACCOUNT />
            <cfset temp["ACCOUNT_TYPE"] = ACCOUNT_TYPE />
            <cfset temp["SETID"] = SETID />
            <cfset temp["STATUS"] = STATUS />
			 <cfset ArrayAppend(retval, temp)>
		</cfloop>

		<cfset result = {} />
		<cfset result['items'] = retVal />
		<cfreturn result />
	</cffunction>


    <cffunction name="MGTPool" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="POOL_NAME" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfset var retVal = ArrayNew(1)>

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.Pool
            SET POOL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.POOL_NAME#" />,
                DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />
            WHERE POOL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.POOL_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.Pool (POOL_NAME, DESCRIPTION)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.POOL_NAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.Pool
            WHERE POOL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.POOL_ID#" />
        </cfif>
    </cfquery>
    
        <cfset temp = {} />
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            <cfset temp["MESSAGE"] = "Updated Successful" />  
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            <cfset temp["MESSAGE"] = "Add Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')> 
            <cfset temp["MESSAGE"] = "Deleted Successful" />
        </cfif>
        
        <cfset ArrayAppend(retval, temp)>
    
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
</cffunction>

<cffunction name="getReconStatus" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="RECONSTATUSID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT RECONSTATUS_ID,STATUS_NAME,DESCRIPTION FROM FELLOWS_LEDGER.ReconStatus 
        <cfif len(arguments.RECONSTATUSID)>
            WHERE RECONSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONSTATUSID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["STATUS_ID"] = RECONSTATUS_ID />
                <cfset temp["STATUS_NAME"] = STATUS_NAME />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTReconStatus" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="STATUS_NAME" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfset var retVal = ArrayNew(1)>

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.ReconStatus
            SET STATUS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS_NAME#" />,
                DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />
            WHERE STATUS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.ReconStatus (STATUS_NAME, DESCRIPTION)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS_NAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.ReconStatus
            WHERE STATUS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS_ID#" />
        </cfif>
    </cfquery>
    
        <cfset temp = {} />
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            <cfset temp["MESSAGE"] = "Updated Successful" />  
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            <cfset temp["MESSAGE"] = "Add Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')> 
            <cfset temp["MESSAGE"] = "Deleted Successful" />
        </cfif>
        
        <cfset ArrayAppend(retval, temp)>
    
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
</cffunction>

<cffunction name="getFFL" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="FFL_ID" type="string" required="false" default=""/>
    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
        SELECT FFL_ID,JOURNALNUMBER,TRANSACTION_DATE,TRANSACTION_TYPE,START_DATE,END_DATE,VENDOR_ID,VENDOR_NAME,EMPLID,PURCHASE_AMOUNT,DEPTID,FUND_GROUP,FUND_TYPE,FUND,PROJECT,ACCOUNT,PAYMENT_TYPE,REQUISITION_NUM,PO,DESCRIPTION,RECEIPTS,RECONCILED,RECONCILED_DATE,RECONCILED_NOTES,STATUS,CREATEDBYID,CREATEDBYDATE,MODIFIEDBYID,MODIFIEDBYDATE
        FROM FELLOWS_LEDGER.FFL
        <cfif len(arguments.FFL_ID)>
            WHERE FFL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FFL_ID#" />
        </cfif>
        ORDER BY FFL_ID ASC
    </cfquery>
    <cfloop query="results">
            <cfset temp = {} />
            <cfset temp["FFL_ID"] = FFL_ID />
            <cfset temp["JOURNALNUMBER"] = JOURNALNUMBER />
            <cfset temp["TRANSACTION_DATE"] = TRANSACTION_DATE />
            <cfset temp["TRANSACTION_TYPE"] = TRANSACTION_TYPE />
            <cfset temp["START_DATE"] = START_DATE />
            <cfset temp["END_DATE"] = END_DATE />
            <cfset temp["VENDOR_ID"] = VENDOR_ID />
            <cfset temp["VENDOR_NAME"] = VENDOR_NAME />
            <cfset temp["EMPLID"] = EMPLID />
            <cfset temp["PURCHASE_AMOUNT"] = PURCHASE_AMOUNT />
            <cfset temp["DEPTID"] = DEPTID />
            <cfset temp["FUND_GROUP"] = FUND_GROUP />
            <cfset temp["FUND_TYPE"] = FUND_TYPE />
            <cfset temp["FUND"] = FUND />
            <cfset temp["PROJECT"] = PROJECT />
            <cfset temp["ACCOUNT"] = ACCOUNT />
            <cfset temp["PAYMENT_TYPE"] = PAYMENT_TYPE />
            <cfset temp["REQUISITION_NUM"] = REQUISITION_NUM />
            <cfset temp["PO"] = PO />
            <cfset temp["DESCRIPTION"] = DESCRIPTION />
            <cfset temp["RECEIPTS"] = RECEIPTS />
            <cfset temp["RECONCILED"] = RECONCILED />
            <cfset temp["RECONCILED_DATE"] = RECONCILED_DATE />
            <cfset temp["RECONCILED_NOTES"] = RECONCILED_NOTES />
            <cfset temp["STATUS"] = STATUS />
            <cfset ArrayAppend(retval, temp)>
    </cfloop>
    <cfset result = {} />
    <cfset result['data'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTFFL" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="FFL_ID" type="string" required="false" />
    <cfargument name="JOURNALNUMBER" type="string" required="false" />
    <cfargument name="TRANSACTION_DATE" type="date" required="false" />
    <cfargument name="TRANSACTION_TYPE" type="string" required="false" />
    <cfargument name="START_DATE" type="date" required="false" />
    <cfargument name="END_DATE" type="date" required="false" />
    <cfargument name="VENDOR_ID" type="string" required="false" />
    <cfargument name="VENDOR_NAME" type="string" required="false" />
    <cfargument name="EMPLID" type="string" required="false" />
    <cfargument name="PURCHASE_AMOUNT" type="string" required="false" />
    <cfargument name="DEPTID" type="string" required="false" />
    <cfargument name="FUND_GROUP" type="string" required="false" />
    <cfargument name="FUND_TYPE" type="string" required="false" />
    <cfargument name="FUND" type="string" required="false" />
    <cfargument name="PROJECT" type="string" required="false" />
    <cfargument name="ACCOUNT" type="string" required="false" />
    <cfargument name="PAYMENT_TYPE" type="string" required="false" />
    <cfargument name="REQUISITION_NUM" type="string" required="false" />
    <cfargument name="PO" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfargument name="RECEIPTS" type="string" required="false" />
    <cfargument name="RECONCILED" type="string" required="false" />
    <cfargument name="RECONCILED_DATE" type="string" required="false" />
    <cfargument name="RECONCILED_NOTES" type="string" required="false" />
    <cfargument name="STATUS" type="string" required="false" />
    <cfargument name="CREATEDBYID" type="string" required="false" />
    <cfargument name="CREATEDBYDATE" type="string" required="false" />
    <cfargument name="MODIFIEDBYID" type="string" required="false" />
    <cfargument name="MODIFIEDBYDATE" type="string" required="false" />

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.FFL
            SET JOURNALNUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.JOURNALNUMBER#" />,
            TRANSACTION_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.TRANSACTION_DATE#" />,
            TRANSACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TRANSACTION_TYPE#" />,
            START_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.START_DATE#" />,
            END_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.END_DATE#" />,
            VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDOR_ID#" />,
            VENDOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDOR_NAME#" />,
            EMPLID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
            PURCHASE_AMOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PURCHASE_AMOUNT#" />,
            DEPTID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
            FUND_GROUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_GROUP#" />,
            FUND_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_TYPE#" />,
            FUND = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND#" />,
            PROJECT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT#" />,
            ACCOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT#" />,
            PAYMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_TYPE#" />,
            REQUISITION_NUM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REQUISITION_NUM#" />,
            PO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PO#" />,
            DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />,
            RECEIPTS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECEIPTS#" />,
            RECONCILED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED#" />,
            RECONCILED_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED_DATE#" />,
            RECONCILED_NOTES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED_NOTES#" />,
            STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#" />,
            MODIFIEDBYID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MODIFIEDBYID#" />,
            MODIFIEDBYDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MODIFIEDBYDATE#" />
            WHERE FFL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FFL_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.FFL (JOURNALNUMBER,TRANSACTION_DATE,START_DATE,END_DATE,TRANSACTION_TYPE,VENDOR_ID,VENDOR_NAME,EMPLID,PURCHASE_AMOUNT,DEPTID,FUND_GROUP,FUND_TYPE,FUND,PROJECT,ACCOUNT,PAYMENT_TYPE,REQUISITION_NUM,PO,DESCRIPTION,RECEIPTS,RECONCILED,RECONCILED_DATE,RECONCILED_NOTES,CREATEDBYID,CREATEDBYDATE)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.JOURNALNUMBER#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TRANSACTION_DATE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TRANSACTION_TYPE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.START_DATE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.END_DATE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDOR_ID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDOR_NAME#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PURCHASE_AMOUNT#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_GROUP#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_TYPE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_TYPE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REQUISITION_NUM#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PO#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECEIPTS#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED_DATE#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RECONCILED_NOTES#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREATEDBYID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREATEDBYDATE#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.FFL
            WHERE FFL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FFL_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            UPDATE FELLOWS_LEDGER.FFL
            SET STATUS = 'D'
            WHERE FFL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FFL_ID#" />
        </cfif>
        
    </cfquery>

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="maxID">
        SELECT MAX(FFL_ID) AS FFL_ID FROM FELLOWS_LEDGER.FFL
    </cfquery>
        
    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" /> 
        <cfset temp["FFL_ID"] = maxID.FFL_ID /> 
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
        <cfset temp["FFL_ID"] = maxID.FFL_ID /> 
    <cfelseif (arguments.MGT_TYPE EQ 'delete')> 
        <cfset temp["MESSAGE"] = "Deleted Successful" />
        <cfset temp["FFL_ID"] = maxID.FFL_ID /> 
    </cfif>
    
    <cfset ArrayAppend(retval, temp)>

    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result /> 
</cffunction>

<cffunction name="getPayment" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="PAYMENTTYPEID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT PAYMENT_ID,PAYMENT_NAME,DESCRIPTION FROM FELLOWS_LEDGER.PaymentType
        <cfif len(arguments.PAYMENTTYPEID)>
            WHERE PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENTTYPEID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["PAYMENT_ID"] = STATUS_ID />
                <cfset temp["PAYMENT_NAME"] = STATUS_NAME />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTPaymentType" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="PAYMENT_NAME" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.PaymentType
            SET PAYMENT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_NAME#" />,
                DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />
            WHERE PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.PaymentType (PAYMENT_ID, PAYMENT_NAME, DESCRIPTION)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_NAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.PaymentType
            WHERE PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_ID#" />
        </cfif>
    </cfquery>
        
        <cfset temp = {} />
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            <cfset temp["MESSAGE"] = "Updated Successful" />  
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            <cfset temp["MESSAGE"] = "Add Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'Delete Successful')> 
            <cfset temp["MESSAGE"] = "Pool Deleted" />
        </cfif>
        
        <cfset ArrayAppend(retval, temp)>
    
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
</cffunction>

<cffunction name="getCategory" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="CATEGORYID" type="string" required="false" default="" />
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT CATEGORY_ID,CATEGORY_NAME,DESCRIPTION FROM FELLOWS_LEDGER.Category
        <cfif len(arguments.CATEGORYID)>
            WHERE CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATEGORYID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["CATEGORY_ID"] = CATEGORY_ID />
                <cfset temp["CATEGORY_NAME"] = CATEGORY_NAME />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTCATEGORY" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfargument name="CATEGORY_NAME" type="string" required="false" />
    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.Category
            SET CATEGORY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATEGORY_NAME#" />,
                DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />
            WHERE CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATEGORY_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.Category (CATEGORY_NAME, DESCRIPTION)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATEGORY_NAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.Category
            WHERE CATEGORY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CATEGORY_ID#" />
        </cfif>
    </cfquery>
            
        <cfset temp = {} />
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            <cfset temp["MESSAGE"] = "Updated Successful" />  
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
        </cfif>
        
        <cfset ArrayAppend(retval, temp)>
    
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
</cffunction>

<cffunction name="getPRS_FUNDv2" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT pf.FUND_ID,pf.EMPLID,(SELECT FULL_NAME FROM FELLOWS_LEDGER.ACTIVE_PEOPLESOFT WHERE EMPLID = pf.EMPLID) as FELLOW,pf.DESCRIPTION,
            pf.START_DATE,pf.END_DATE,pf.SUBMISSION_STATUS,cs.CFS_ID,pf.ENTEREDBYID,pf.ENTEREDDATE,pf.MODIFIEDBYID,pf.MODIFIEDDATE
            FROM FELLOWS_LEDGER.PRS_FUND pf, FELLOWS_LEDGER.CHARTFFIELD_STR cs 
            WHERE pf.CFS_ID = cs.CFS_ID 
        <cfif len(arguments.ID)>
            WHERE FUND_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["ID"] = FUND_ID />
                <cfset temp["CFS_ID"] = CFS_ID />
                <cfset temp["EMPLID"] = EMPLID />
                <cfset temp["FELLOW"] = FELLOW />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset temp["START_DATE"] = START_DATE />
                <cfset temp["END_DATE"] = END_DATE />
                <cfset temp["SUBMISSION_STATUS"] = SUBMISSION_STATUS />
                <cfset temp["ENTEREDBYID"] = ENTEREDBYID />
                <cfset temp["ENTEREDDATE"] = ENTEREDDATE />
                <cfset temp["MODIFIEDBYID"] = MODIFIEDBYID />
                <cfset temp["MODIFIEDDATE"] = MODIFIEDDATE />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['data'] = retVal />
    <cfreturn result />
</cffunction>
<cffunction name="getPRS_FUND" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT Fund_id, CFS_ID, Emplid,Fellow,Description,Start_Date,End_Date,Submission_Status,EnteredById,EnteredDate,ModifiedById,ModifiedDate
            FROM FELLOWS_LEDGER.PRS_FUND
        <cfif len(arguments.ID)>
            WHERE FUND_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["ID"] = FUND_ID />
                <cfset temp["CFS_ID"] = CFS_ID />
                <cfset temp["EMPLID"] = EMPLID />
                <cfset temp["FELLOW"] = FELLOW />
                <cfset temp["DESCRIPTION"] = DESCRIPTION />
                <cfset temp["START_DATE"] = START_DATE />
                <cfset temp["END_DATE"] = END_DATE />
                <cfset temp["SUBMISSION_STATUS"] = SUBMISSION_STATUS />
                <cfset temp["ENTEREDBYID"] = ENTEREDBYID />
                <cfset temp["ENTEREDDATE"] = ENTEREDDATE />
                <cfset temp["MODIFIEDBYID"] = MODIFIEDBYID />
                <cfset temp["MODIFIEDDATE"] = MODIFIEDDATE />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['data'] = retVal />
    <cfreturn result />
</cffunction>
<cffunction name="MGTPRS_FUND" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="ID" type="string" required="false" />
    <cfargument name="EMPLID" type="string" required="false" />
    <cfargument name="FELLOW" type="string" required="false" />
    <cfargument name="DESCRIPTION" type="string" required="false" />
    <cfargument name="DEPTID" type="string" required="false" />
    <cfargument name="FUND_GROUP" type="string" required="false" />
    <cfargument name="FUND_TYPE" type="string" required="false" />
    <cfargument name="START_DATE" type="string" required="false" />
    <cfargument name="END_DATE" type="string" required="false" />
    <cfargument name="SUBMISSION_STATUS" type="string" required="false" />

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.getPRS_FUND
            SET EMPLID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
            FELLOW = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FELLOW#" />,
            DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />,
            DEPTID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
            FUND_GROUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_GROUP#" />,
            FUND_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_TYPE#" />,
            START_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.START_DATE#" />,
            END_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.END_DATE#" />,
            SUBMISSION_STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SUBMISSION_STATUS#" />
            WHERE FUND_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.getPRS_FUND (EMPLID, FELLOW, DESCRIPTION, DEPTID, FUND_GROUP, FUND_TYPE, START_DATE, END_DATE, SUBMISSION_STATUS)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FELLOW#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DESCRIPTION#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_GROUP#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_TYPE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.START_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.END_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SUBMISSION_STATUS#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.getPRS_FUND
            WHERE FUND_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
    </cfquery>

    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>

    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="getT32" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default=""/>
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT TRANSACTION_ID,VENDORNAME,VENDORID,EMPLID,REQUISITION_DATE,EXPENSED_DATE,NOTES,TRANSACTION_TYPE, PRIMARY_BALANCE, DEBIT, CREDIT, CFS,PO,PAYMENT_METHOD,ENTEREDBYID,CREATEDBYDATE,UPDATEDBYID,UPDATEDDATE,STATUS
            FROM FELLOWS_LEDGER.T32_Checkbook_Accounts
            WHERE STATUS = 'A'
        <cfif len(arguments.ID)>
            AND TRANSACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["ID"] = TRANSACTION_ID />
                <cfset temp["CFS"] = CFS />
                <cfset temp["VENDORNAME"] = VENDORNAME />
                <cfset temp["VENDORID"] = VENDORID />
                <cfset temp["EMPLID"] = EMPLID />
                <cfset temp["EXPENSED_DATE"] = '#DATEFORMAT(EXPENSED_DATE,"mm/dd/yyyy")#' />
                <cfset temp["REQUISITION_DATE"] = '#DATEFORMAT(REQUISITION_DATE,"mm/dd/yyyy")#' />
                <cfset temp["NOTES"] = NOTES />
                <cfset temp["TYPE"] = TRANSACTION_TYPE />
                <cfset temp["PRIMARY_BALANCE"] = PRIMARY_BALANCE />
                <cfset temp["DEBIT"] = DEBIT />
                <cfset temp["CREDIT"] = CREDIT />
                <cfset temp["PO"] = PO />
                <cfset temp["PAYMENT_METHOD"] = PAYMENT_METHOD />
                <cfset temp["STATUS"] = STATUS />
                <cfset temp["ENTEREDBYID"] = ENTEREDBYID />
                <cfset temp["CREATEDBYDATE"] = DATEFORMAT(CREATEDBYDATE,"mm/dd/yyyy") />
                <cfset temp["UPDATEDBYID"] = UPDATEDBYID />
                <cfset temp["UPDATEDDATE"] = DATEFORMAT(UPDATEDDATE,"mm/dd/yyyy") />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['data'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTT32" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="ID" type="string" required="false" />
    <cfargument name="VENDORNAME" type="string" required="false" />
    <cfargument name="VENDORID" type="string" required="false" />
    <cfargument name="EMPLID" type="string" required="false" />
    <cfargument name="REQUISITION_DATE" type="date" required="false" />
    <cfargument name="EXPENSED_DATE" type="date" required="false" />
    <cfargument name="NOTES" type="string" required="false" />
    <cfargument name="TRANSACTION_TYPE" type="string" required="false" />
    <cfargument name="DEBIT" type="numeric" required="false" />
    <cfargument name="CREDIT" type="numeric" required="false" />
    <cfargument name="CFS" type="string" required="false" />
    <cfargument name="PO" type="string" required="false" />
    <cfargument name="PAYMENT_METHOD" type="string" required="false" />
    <cfargument name="STATUS" type="string" required="false" />
    <cfargument name="ENTEREDBYID" type="string" required="false" />
    <cfargument name="CREATEDBYDATE" type="date" required="false" />
    <cfargument name="UPDATEDBYID" type="numeric" required="false" />
    <cfargument name="UPDATEDDATE" type="string" required="false" />
    
    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.T32_Checkbook_Accounts
            SET VENDORNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDORNAME#" />,
                VENDORID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDORID#" />,
                EMPLID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                REQUISITION_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REQUISITION_DATE#" />,
                EXPENSED_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSED_DATE#" />,
                NOTES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NOTES#" />,
                TRANSACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TRANSACTION_TYPE#" />,
                DEBIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEBIT#" />,
                CREDIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREDIT#" />,
                CFS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
                PO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PO#" />,
                PAYMENT_METHOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_METHOD#" />,
                STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#" />,
                UPDATEDBYID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UPDATEDBYID#" />,
                UPDATEDDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UPDATEDDATE#" />,
                
            WHERE TRANSACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.T32_Checkbook_Accounts (VENDORNAME, VENDORID, EMPLID, REQUISITION_DATE, EXPENSED_DATE, NOTES, DEBIT, TRANSACTION_TYPE, CREDIT, CFS,PO,PAYMENT_METHOD,STATUS,ENTEREDBYID,CREATEDBYDATE,UPDATEDBYID,UPDATEDDATE)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDORNAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VENDORID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.REQUISITION_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EXPENSED_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NOTES#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TRANSACTION_TYPE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEBIT#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREDIT#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PO#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAYMENT_METHOD#" />,
                    )
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            UPDATE FELLOWS_LEDGER.T32_Checkbook_Accounts
            SET STATUS = 'I'
            WHERE TRANSACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.T32_Checkbook_Accounts
            WHERE TRANSACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
    </cfquery>
                
    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />  
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
        <cfset temp["MESSAGE"] = "Soft Delete Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>
    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="getFELLOW" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default="" />
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT FELLOW_ID,CFS,PHOTO,EMPLID,CREDIT_LINE,PRS_AMOUNT,PROGRAM_START,PROGRAM_COMPLETE,STATUS FROM FELLOWS_LEDGER.FELLOW
        <cfif len(arguments.ID)>
            WHERE FELLOW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["FELLOW_ID"] = FELLOW_ID />
                <cfset temp["CFS"] = CFS />
                <cfset temp["PHOTO"] = PHOTO />
                <cfset temp["EMPLID"] = EMPLID />
                <cfset temp["CREDIT_LINE"] = CREDIT_LINE />
                <cfset temp["PRS_AMOUNT"] = PRS_AMOUNT />
                <cfset temp["PROGRAM_START"] = PROGRAM_START />
                <cfset temp["PROGRAM_COMPLETE"] = PROGRAM_COMPLETE />
                <cfset temp["STATUS"] = STATUS />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTFELLOW" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="FELLOW_ID" type="string" required="false" />
    <cfargument name="CFS" type="string" required="false" />
    <cfargument name="PHOTO" type="string" required="false" />
    <cfargument name="EMPLID" type="string" required="false" />
    <cfargument name="CREDIT_LINE" type="string" required="false" />
    <cfargument name="PRS_AMOUNT" type="string" required="false" />
    <cfargument name="PROGRAM_START" type="string" required="false" />
    <cfargument name="PROGRAM_COMPLETE" type="string" required="false" />
    <cfargument name="STATUS" type="string" required="false" />

    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.FELLOW
            SET CFS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
                PHOTO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PHOTO#" />,
                EMPLID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                CREDIT_LINE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREDIT_LINE#" />,
                PRS_AMOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRS_AMOUNT#" />,
                PROGRAM_START = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROGRAM_START#" />,
                PROGRAM_COMPLETE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROGRAM_COMPLETE#" />,
                STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#" />
            WHERE FELLOW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FELLOW_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.FELLOW (CFS, PHOTO, EMPLID, CREDIT_LINE, PRS_AMOUNT, PROGRAM_START, PROGRAM_COMPLETE)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PHOTO#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREDIT_LINE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRS_AMOUNT#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROGRAM_START#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROGRAM_COMPLETE#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            UPDATE FELLOWS_LEDGER.FELLOW
            SET STATUS = 'I'
            WHERE FELLOW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FELLOW_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.FELLOW
            WHERE FELLOW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FELLOW_ID#" />
        </cfif>
    </cfquery>

    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
        <cfset temp["MESSAGE"] = "Soft Delete Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>

    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>


<cffunction name="getACADEMA" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default="" />
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT ACADEMIA_ID,UNIVERSITY,ATTENDED_TYPE,START_DATE,END_DATE,YEAR_GRADUATED,STATUS FROM FELLOWS_LEDGER.ClassCode
        <cfif len(arguments.ACADEMIA_ID)>
            WHERE ACADEMIA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["ACADEMIA_ID"] = ACADEMIA_ID />
                <cfset temp["UNIVERSITY"] = UNIVERSITY />
                <cfset temp["ATTENDED_TYPE"] = ATTENDED_TYPE />
                <cfset temp["START_DATE"] = START_DATE />
                <cfset temp["END_DATE"] = END_DATE />
                <cfset temp["YEAR_GRADUATED"] = YEAR_GRADUATED />
                <cfset temp["STATUS"] = STATUS />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTACADEMIA" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="ACADEMIA_ID" type="string" required="false" />
    <cfargument name="UNIVERSITY" type="string" required="false" />
    <cfargument name="ATTENDED_TYPE" type="string" required="false" />
    <cfargument name="START_DATE" type="string" required="false" />
    <cfargument name="END_DATE" type="string" required="false" />
    <cfargument name="YEAR_GRADUATED" type="string" required="false" />
    <cfargument name="STATUS" type="string" required="false" />

    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.ACADEMIA
            SET UNIVERSITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UNIVERSITY#" />,
                ATTENDED_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ATTENDED_TYPE#" />,
                START_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.START_DATE#" />,
                END_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.END_DATE#" />,
                YEAR_GRADUATED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.YEAR_GRADUATED#" />
            WHERE ACADEMIA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACADEMIA_ID#" />
            AND STATUS = 'A'
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.ACADEMIA (UNIVERSITY, ATTENDED_TYPE, START_DATE, END_DATE, YEAR_GRADUATED)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UNIVERSITY#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ATTENDED_TYPE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.START_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.END_DATE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.YEAR_GRADUATED#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            UPDATE FELLOWS_LEDGER.ACADEMIA
            SET STATUS = 'I'
            WHERE ACADEMIA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACADEMIA_ID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.ACADEMIA
            WHERE ACADEMIA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACADEMIA_ID#" />
        </cfif>
    </cfquery>
    
    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
        <cfset temp["MESSAGE"] = "Soft Delete Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>

    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="getCFS" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="CFS_ID" type="string" required="false" default="" />
        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT CFS_ID,PRIMARY_BALANCE,STEWARD_NAME,EMPLID,CFS_DISPLAY,FREE_BALANCE,DEPTID,FG,FT,FUND,ACCOUNT,PC_BU,PROJECT_ID,ACTIVITY,YEAR,FUND_DESCRIPTION,DONOR_RESTRICTION
            FROM FELLOWS_LEDGER.CHARTFFIELD_STR
        <cfif len(arguments.CFS_ID)>
            WHERE CFS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS_ID#" />
        </cfif>
        </cfquery>
        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["CFS_ID"] = CFS_ID />
                <cfset temp["PRIMARY_BALANCE"] = PRIMARY_BALANCE />
                <cfset temp["CFS_DESC"] = CFS_DESC />
                <cfset temp["STEWARD_NAME"] = STEWARD_NAME />
                <cfset temp["EMPLID"] = EMPLID />
                <cfset temp["CFS_DISPLAY"] = CFS_DISPLAY />
                <cfset temp["FREE_BALANCE"] = FREE_BALANCE />
                <cfset temp["DEPTID"] = DEPTID />
                <cfset temp["FG"] = FG />
                <cfset temp["FT"] = FT />
                <cfset temp["FUND"] = FUND />
                <cfset temp["ACCOUNT"] = ACCOUNT />
                <cfset temp["PC_BU"] = PC_BU />
                <cfset temp["PROJECT_ID"] = PROJECT_ID />
                <cfset temp["ACTIVITY"] = ACTIVITY />
                <cfset temp["YEAR"] = YEAR />
                <cfset temp["FUND_DESCRIPTION"] = FUND_DESCRIPTION />
                <cfset temp["DONOR_RESTRICTION"] = DONOR_RESTRICTION />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
    <cfset result = {} />
    <cfset result['data'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTCFS" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="false" />
    <cfargument name="CFS_ID" type="string" required="false" />
    <cfargument name="PRIMARY_BALANCE" type="string" required="false" />
    <cfargument name="STEWARD_NAME" type="string" required="false" />
     <cfargument name="EMPLID" type="string" required="false" />
    <cfargument name="CFS_DISPLAY" type="string" required="false" />
    <cfargument name="FREE_BALANCE" type="string" required="false" />
    <cfargument name="DEPTID" type="string" required="false" />
    <cfargument name="FG" type="string" required="false" />
    <cfargument name="FT" type="string" required="false" />
    <cfargument name="FUND" type="string" required="false" />
    <cfargument name="ACCOUNT" type="string" required="false" />
    <cfargument name="PC_BU" type="string" required="false" />
    <cfargument name="PROJECT_ID" type="string" required="false" />
    <cfargument name="ACTIVITY" type="string" required="false" />
    <cfargument name="YEAR" type="string" required="false" />
    <cfargument name="FUND_DESCRIPTION" type="string" required="false" />
    <cfargument name="DONOR_RESTRICTION" type="string" required="false" />

    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.CHARTFFIELD_STR
            SET PRIMARY_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRIMARY_BALANCE#" />,
                STEWARD_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STEWARD_NAME#" />,
                EMPLID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                CFS_DISPLAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS_DISPLAY#" />,
                FREE_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FREE_BALANCE#" />,
                DEPTID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
                FG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FG#" />,
                FT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FT#" />,
                FUND = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND#" />,
                ACCOUNT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT#" />,
                PC_BU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PC_BU#" />,
                PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_ID#" />,
                ACTIVITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTIVITY#" />,
                YEAR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.YEAR#" />,
                FUND_DESCRIPTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_DESCRIPTION#" />,
                DONOR_RESTRICTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DONOR_RESTRICTION#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.CHARTFFIELD_STR (PRIMARY_BALANCE, STEWARD_NAME,EMPLID, CFS_DISPLAY, FREE_BALANCE, DEPTID, FG, FT, FUND, ACCOUNT, PC_BU, PROJECT_ID, ACTIVITY, YEAR, FUND_DESCRIPTION, DONOR_RESTRICTION)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRIMARY_BALANCE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STEWARD_NAME#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS_DISPLAY#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FREE_BALANCE#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FG#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FT#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PC_BU#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_ID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTIVITY#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.YEAR#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_DESCRIPTION#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DONOR_RESTRICTION#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            UPDATE FELLOWS_LEDGER.CHARTFFIELD_STR
            SET STATUS = 'I'
            WHERE CFS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS_ID#" />
        </cfif>
    </cfquery>

    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>

    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="get" access="remote" returntype="any" returnformat="JSON">

</cffunction>

<cffunction name="getVendorTransaction" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="ID" type="string" required="false" default="" />
    <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
            SELECT VendorName,VendorID,EffectiveDate,CMEItem,Fund,Account,Amount,ClassCode,PurchaseOrder,Notes,Reconciled,EnteredById,CreatedByDate,UpdatedById, UpdatedDate
            FROM FELLOWS_LEDGER.VendorTransaction
        <cfif len(arguments.ID)>
            WHERE ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
    </cfquery>

    <cfloop query="results">
            <cfset temp = {} />
            <cfset temp["ID"] = ID />
            <cfset temp["VendorName"] = VendorName />
            <cfset temp["VendorID"] = VendorID />
            <cfset temp["EffectiveDate"] = EffectiveDate />
            <cfset temp["Notes"] = Notes />
            <cfset temp["EnteredById"] = EnteredById />
            <cfset temp["CreatedByDate"] = CreatedByDate />
            <cfset temp["UpdatedById"] = UpdatedById />
            <cfset temp["UpdatedDate"] = UpdatedDate />
            <cfset ArrayAppend(retval, temp)>
    </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTVendorTransaction" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="true" />
    <cfargument name="ID" type="string" required="false" /> 
    <cfargument name="VendorName" type="string" required="false" />
    <cfargument name="VendorID" type="string" required="false" />
    <cfargument name="EffectiveDate" type="string" required="false" />
    <cfargument name="Notes" type="string" required="false" />
    <cfargument name="EnteredById" type="string" required="false" />
    <cfargument name="CreatedByDate" type="string" required="false" />
    <cfargument name="UpdatedById" type="string" required="false" />
    <cfargument name="UpdatedDate" type="string" required="false" />
    <cfset var retVal = ArrayNew(1)>

    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
         <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.VendorTransaction
            SET VendorName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorName#" />,
                VendorID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorID#" />,
                EffectiveDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EffectiveDate#" />,
                Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Notes#" />,
                EnteredById = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EnteredById#" />,
                CreatedByDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CreatedByDate#" />,
                UpdatedById = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UpdatedById#" />,
                UpdatedDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UpdatedDate#" />
            WHERE ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
         <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.VendorTransaction (VendorName, VendorID, EffectiveDate, Notes, EnteredById, CreatedByDate, UpdatedById, UpdatedDate)
            VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorName#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorID#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EffectiveDate#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Notes#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EnteredById#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CreatedByDate#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UpdatedById#" />,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.UpdatedDate#" />)
         <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.VendorTransaction
            WHERE ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
        </cfif>
    </cfquery>
</cffunction>

<cffunction name="getFellowsLedger" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="FellowsLedgerID" type="string" required="false" default="" />
    <cfargument name="EntryID" type="string" required="false" />
    <cfargument name="Transaction_Date" type="string" required="false" />
    <cfargument name="JournalNumber" type="string" required="false" />
    <cfargument name="Description" type="string" required="false" />
    <cfargument name="CFS" type="string" required="false" />
    <cfargument name="Category" type="string" required="false" />
    <cfargument name="Amount" type="string" required="false" />
    <cfargument name="PaymentMethod" type="string" required="false" />
    <cfargument name="VendorSupplier" type="string" required="false" />
    <cfargument name="VendorID" type="string" required="false" />
    <cfargument name="ReceiptInvoice" type="string" required="false" />
    <cfargument name="BeginningBalance" type="string" required="false" />
    <cfargument name="EncumberedBalance" type="string" required="false" />
    <cfargument name="CurrentBalance" type="string" required="false" />
    <cfargument name="ReconStatusID" type="string" required="false" />
    <cfargument name="ReconDate" type="string" required="false" />
    <cfargument name="ReconNotes" type="string" required="false" />
    <cfargument name="Beginning_Balance" type="string" required="false" />
    <cfargument name="Encumbered_Balance" type="string" required="false" />
    <cfargument name="ClassCode" type="string" required="false" />
    <cfargument name="Effective_date" type="string" required="false" />
    <cfargument name="Purchase_order" type="string" required="false" />
    <cfargument name="ReconNotification" type="string" required="false" />
    <cfargument name="Pool" type="string" required="false" />6
    <cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
        SELECT EntryID,Transaction_Date,JournalNumber,Description,CFS,Category,Amount,
            PaymentMethod,VendorSupplier,VendorID,ReceiptInvoice,BeginningBalance,EncumberedBalance,CurrentBalance,ReconStatusID,
            ReconDate,ReconNotes,Beginning_Balance,Encumbered_Balance,ClassCode,Effective_date,Purchase_order,ReconNotification,Pool
        FROM FELLOWS_LEDGER.fellows_ledger   
    <cfif len(arguments.EntryID)>
        WHERE EntryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EntryID#" />
    </cfif>
    </cfquery>

    <cfloop query="results">
            <cfset temp = {} />
            <cfset temp["EntryID"] = EntryID />
            <cfset temp["Transaction_Date"] = Transaction_Date />
            <cfset temp["JournalNumber"] = JournalNumber />
            <cfset temp["Description"] = Description />
            <cfset temp["CFS"] = CFS />
            <cfset temp["Category"] = Category />
            <cfset temp["Amount"] = Amount />
            <cfset temp["PaymentMethod"] = PaymentMethod />
            <cfset temp["VendorSupplier"] = VendorSupplier />
            <cfset temp["VendorID"] = VendorID />
            <cfset temp["ReceiptInvoice"] = ReceiptInvoice />
            <cfset temp["BeginningBalance"] = BeginningBalance />
            <cfset temp["EncumberedBalance"] = EncumberedBalance />
            <cfset temp["CurrentBalance"] = CurrentBalance />
            <cfset temp["ReconStatusID"] = ReconStatusID />
            <cfset temp["ReconDate"] = ReconDate />
            <cfset temp["ReconNotes"] = ReconNotes />
            <cfset temp["Beginning_Balance"] = Beginning_Balance />
            <cfset temp["Encumbered_Balance"] = Encumbered_Balance />
            <cfset temp["ClassCode"] = ClassCode />
            <cfset temp["Effective_date"] = Effective_date />
            <cfset temp["Purchase_order"] = Purchase_order />
            <cfset temp["ReconNotification"] = ReconNotification />
            <cfset temp["Pool"] = Pool />
            <cfset ArrayAppend(retval, temp)>
    </cfloop>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />
</cffunction>

<cffunction name="MGTFellowsLedger" access="remote" returntype="any" returnformat="JSON">
    <cfargument name="MGT_TYPE" type="string" required="true" />    
    <cfargument name="EntryID" type="string" required="false" />
    <cfargument name="Transaction_Date" type="string" required="false" />
    <cfargument name="JournalNumber" type="string" required="false" />
    <cfargument name="Description" type="string" required="false" />
    <cfargument name="CFS" type="string" required="false" />
    <cfargument name="Category" type="string" required="false" />
    <cfargument name="Amount" type="string" required="false" />
    <cfargument name="PaymentMethod" type="string" required="false" />
    <cfargument name="VendorSupplier" type="string" required="false" />
    <cfargument name="VendorID" type="string" required="false" />
    <cfargument name="ReceiptInvoice" type="string" required="false" />
    <cfargument name="BeginningBalance" type="string" required="false" />
    <cfargument name="EncumberedBalance" type="string" required="false" />
    <cfargument name="CurrentBalance" type="string" required="false" />
    <cfargument name="ReconStatusID" type="string" required="false" />
    <cfargument name="ReconDate" type="string" required="false" />
    <cfargument name="ReconNotes" type="string" required="false" />
    <cfargument name="Beginning_Balance" type="string" required="false" />
    <cfargument name="Encumbered_Balance" type="string" required="false" />
    <cfargument name="ClassCode" type="string" required="false" />
    <cfargument name="Effective_date" type="string" required="false" />
    <cfargument name="Purchase_order" type="string" required="false" />
    <cfargument name="ReconNotification" type="string" required="false" />
    <cfargument name="Pool" type="string" required="false" />
<cfset var retVal = ArrayNew(1)>
    <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            UPDATE FELLOWS_LEDGER.FELLOWSHIP_LEDGER
            SET Transaction_Date = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Transaction_Date#" />,
                JournalNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.JournalNumber#" />,
                Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Description#" />,
                CFS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
                Category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Category#" />,
                Amount = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Amount#" />,
                PaymentMethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PaymentMethod#" />,
                VendorSupplier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorSupplier#" />,
                VendorID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorID#" />,
                ReceiptInvoice = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReceiptInvoice#" />,
                BeginningBalance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BeginningBalance#" />,
                EncumberedBalance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EncumberedBalance#" />,
                CurrentBalance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CurrentBalance#" />,
                ReconStatusID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconStatusID#" />,
                ReconDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconDate#" />,
                ReconNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconNotes#" />,
                Beginning_Balance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Beginning_Balance#" />,
                Encumbered_Balance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Encumbered_Balance#" />,
                ClassCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ClassCode#" />,
                Effective_date = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Effective_date#" />,
                Purchase_order = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Purchase_order#" />,
                ReconNotification = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconNotification#" />,
                Pool = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pool#" />
            WHERE EntryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EntryID#" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            INSERT INTO FELLOWS_LEDGER.FELLOWSHIP_LEDGER (Transaction_Date, JournalNumber, Description, CFS, Category, Amount, PaymentMethod, VendorSupplier, VendorID, ReceiptInvoice, BeginningBalance, EncumberedBalance, CurrentBalance, ReconStatusID, ReconDate, ReconNotes, Beginning_Balance, Encumbered_Balance, ClassCode, Effective_date, Purchase_order, ReconNotification, Pool)
            VALUES (<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Transaction_Date#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Description#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFS#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Category#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Amount#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PaymentMethod#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorSupplier#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.VendorID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReceiptInvoice#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BeginningBalance#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EncumberedBalance#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CurrentBalance#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconStatusID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconDate#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconNotes#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Beginning_Balance#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Encumbered_Balance#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ClassCode#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Effective_date#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Purchase_order#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ReconNotification#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Pool#" />)
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            DELETE FROM FELLOWS_LEDGER.FELLOWSHIP_LEDGER
            WHERE EntryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EntryID#" />
        </cfif>
    </cfquery>

    <cfset temp = {} />
    <cfif (arguments.MGT_TYPE EQ 'edit')>
        <cfset temp["MESSAGE"] = "Updated Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'add')>
        <cfset temp["MESSAGE"] = "Add Successful" />
    <cfelseif (arguments.MGT_TYPE EQ 'delete')>
        <cfset temp["MESSAGE"] = "Delet Successful" />
    </cfif>

    <cfset ArrayAppend(retval, temp)>
    <cfset result = {} />
    <cfset result['items'] = retVal />
    <cfreturn result />

    </cffunction>
 
    <!--- Function to handle PDF file uploads --->
    <cffunction name="uploadFile" access="remote" returnformat="json" output="false">
        <!--- Define the arguments expected. For file uploads, you might not need to define specific arguments. --->
        <cfargument name="file" type="any" required="no">

        <!--- Initialize a structure to hold the response --->
        <cfset var result = { success = false,message = "", data = {} }>
        <!--- Try-Catch block for error handling --->
        <cftry>
            <!--- Check if a file has been uploaded --->
            <cfif structKeyExists(FORM, "file")>
                <!--- Validate the file type (assuming PDFs are being uploaded) --->
                <cfif fileExists(FORM.file) AND listLast(FORM.file, ".") IS "pdf">
                    <!--- Define the path where the file will be saved --->
                    <cfset var savePath = "assets/files/" & FORM.file.fileName>

                    <!--- Attempt to upload the file --->
                    <cffile action="upload" filefield="file" destination="#savePath#" accept="application/pdf">

                    <!--- Update result structure for successful upload --->
                    <cfset result.success = true>
                    <cfset result.message = "File uploaded successfully.">
                    <cfset result.data.fileName = FORM.file.fileName>
                <cfelse>
                    <cfthrow message="Invalid file type. Only PDF files are allowed.">
                </cfif>
            <cfelse>
                <cfthrow message="No file provided.">
            </cfif>

            <!--- Catch block for handling errors --->
            <cfcatch type="any">
                <cfset result.message = "Error: " & cfcatch.message>
            </cfcatch>
        </cftry>

        <!--- Return the result as a JSON object --->
        <cfreturn serializeJSON(result)>
    </cffunction>



    <cffunction name="getDirectoryContents" access="remote" returnType="any" output="false" returnFormat="JSON">
        <cfargument name="path" type="string" required="yes" default="../images/fellows/">
        
        <cfset var directory = "">
        <cfset var retVal = ArrayNew(1)>
        <!--- Construct the full path to the directory --->
        <cfset directory = ExpandPath(arguments.path)>
        <!--- Check if the directory exists --->
        <cfif directoryExists(directory)>
            <!--- Get the list of files in the directory --->
            <cfdirectory action="list" directory="#directory#" name="results" sort="name ASC">
            
            <!--- Loop through the files and add their details to the result array --->
            <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["name"] = name />
                <cfset temp["size"] = size />
                <cfset temp["type"] = type />
                <cfset temp["dateLastModified"] = dateLastModified />
                <cfset temp["imagePath"] = directory />
                <cfset ArrayAppend(retval, temp)>
            </cfloop>
            <cfset result = {} />
            <cfset result['items'] = retVal />
            <cfreturn result />

        <cfelse>
            <!--- Return an error message if the directory does not exist --->
            <cfreturn serializeJSON({error: "Directory does not exist."})>
        </cfif>
    </cffunction>

    <cffunction name="getEndowmentAccounts" access="remote" returnType="any" output="false" returnFormat="JSON">
        <cfargument name="ID" type="string" required="false" default="" />
        <cfset var retVal = ArrayNew(1)>
            <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="results">
                SELECT EA_ID,STEWARD_NAME,DEPTID,FG,FUND_PROJECT,DONOR_RESTRICTION,FT,BEGINNING_BALANCE,TOTAL_EXPENSES,CURRENT_BALANCE,ENCUMBERED_BALANCE,FREE_BALANCE,NET_BALANCE,CREATEDBYID,CREATEDBYDATE,MODIFIEDBYID,MODIFIEDBYDATE
                FROM FELLOWS_LEDGER.ENDOWMENT_ACCOUNTS
            <cfif len(arguments.ID)>
                WHERE EA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
            </cfif>
        </cfquery>

        <cfloop query="results">
                <cfset temp = {} />
                <cfset temp["ID"] = EA_ID />
                <cfset temp["STEWARD_NAME"] = STEWARD_NAME />
                <cfset temp["DEPTID"] = DEPTID />
                <cfset temp["FG"] = FG />
                <cfset temp["FUND_PROJECT"] = FUND_PROJECT />
                <cfset temp["DONOR_RESTRICTION"] = DONOR_RESTRICTION />
                <cfset temp["FT"] = FT />
                <cfset temp["BEGINNING_BALANCE"] = BEGINNING_BALANCE />
                <cfset temp["TOTAL_EXPENSES"] = TOTAL_EXPENSES />
                <cfset temp["CURRENT_BALANCE"] = CURRENT_BALANCE />
                <cfset temp["ENCUMBERED_BALANCE"] = ENCUMBERED_BALANCE />
                <cfset temp["FREE_BALANCE"] = FREE_BALANCE />
                <cfset temp["NET_BALANCE"] = NET_BALANCE />
                <cfset ArrayAppend(retval, temp)>
        </cfloop>
        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
    </cffunction>
    
    <cffunction name="MGTEndowmentAccount" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="MGT_TYPE" type="string" required="true" /> 
        <cfargument name="ID" type="string" required="false" default="" />
        <cfargument name="STEWARD_NAME" type="string" required="false" />
        <cfargument name="DEPTID" type="string" required="false" />
        <cfargument name="FG" type="string" required="false" />
        <cfargument name="FUND_PROJECT" type="string" required="false" />
        <cfargument name="DONOR_RESTRICTION" type="string" required="false" />
        <cfargument name="FT" type="string" required="false" />
        <cfargument name="BEGINNING_BALANCE" type="string" required="false" />
        <cfargument name="TOTAL_EXPENSES" type="string" required="false" />
        <cfargument name="CURRENT_BALANCE" type="string" required="false" />
        <cfargument name="ENCUMBERED_BALANCE" type="string" required="false" />
        <cfargument name="FREE_BALANCE" type="string" required="false" />
        <cfargument name="NET_BALANCE" type="string" required="false" />

        <cfset var retVal = ArrayNew(1)>
        <cfquery username="ErnestPenaJr" password="$268RedDragons" datasource="fellows_ledger" name="manage">
            <cfif (arguments.MGT_TYPE EQ 'edit')>
                UPDATE FELLOWS_LEDGER.ENDOWMENT_ACCOUNTS
                SET STEWARD_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STEWARD_NAME#" />,
                    DEPTID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
                    FG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FG#" />,
                    FUND_PROJECT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_PROJECT#" />,
                    DONOR_RESTRICTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DONOR_RESTRICTION#" />,
                    FT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FT#" />,
                    BEGINNING_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BEGINNING_BALANCE#" />,
                    TOTAL_EXPENSES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TOTAL_EXPENSES#" />,
                    CURRENT_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CURRENT_BALANCE#">,
                    ENCUMBERED_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ENCUMBERED_BALANCE#" />,
                    FREE_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FREE_BALANCE#" />,
                    NET_BALANCE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NET_BALANCE#" />,
                    MODIFIEDBYID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MODIFIEDBYID#" />,
                    MODIFIEDBYDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MODIFIEDBYDATE#" />
                WHERE EA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
            <cfelseif (arguments.MGT_TYPE EQ 'add')>
                INSERT INTO FELLOWS_LEDGER.ENDOWMENT_ACCOUNTS (STEWARD_NAME, DEPTID, FG, FUND_PROJECT, DONOR_RESTRICTION, FT, BEGINNING_BALANCE, TOTAL_EXPENSES, CURRENT_BALANCE, ENCUMBERED_BALANCE, FREE_BALANCE, NET_BALANCE, CREATEDBYID, CREATEDBYDATE)
                VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STEWARD_NAME#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DEPTID#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FG#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FUND_PROJECT#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DONOR_RESTRICTION#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FT#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BEGINNING_BALANCE#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TOTAL_EXPENSES#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CURRENT_BALANCE#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ENCUMBERED_BALANCE#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FREE_BALANCE#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NET_BALANCE#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREATEDBYID#" />,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CREATEDBYDATE#" />)
            <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
                UPDATE FELLOWS_LEDGER.ENDOWMENT_ACCOUNTS
                SET STATUS = 'I'
                WHERE EA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
            <cfelseif (arguments.MGT_TYPE EQ 'delete')>
                DELETE FROM FELLOWS_LEDGER.ENDOWMENT_ACCOUNTS
                WHERE EA_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#" />
            </cfif>
        </cfquery>

        <cfset temp = {} />
        <cfif (arguments.MGT_TYPE EQ 'edit')>
            <cfset temp["MESSAGE"] = "Updated Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'add')>
            <cfset temp["MESSAGE"] = "Add Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'soft_delete')>
            <cfset temp["MESSAGE"] = "Delet Successful" />
        <cfelseif (arguments.MGT_TYPE EQ 'delete')>
            <cfset temp["MESSAGE"] = "Delet Successful" />
        </cfif>
        <cfset ArrayAppend(retval, temp)>

        <cfset result = {} />
        <cfset result['items'] = retVal />
        <cfreturn result />
    </cffunction>

</cfcomponent>