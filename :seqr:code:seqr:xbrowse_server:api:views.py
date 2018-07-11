@csrf_exempt
@login_required
@log_request('alyssa')
def alyssa(request):
        cursor = connection.cursor()
        #cursor.execute("SELECT * from gc_1")
        cursor.execute("SELECT sample, dbsnp_ins_del_ratio, num_singletons, company FROM gc_2 ORDER BY company")
        columns = [col[0] for col in cursor.description]
        individual_rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        individuals_json = []

        col_json = []

        #ADDRESS
        #Column type determined by type(first row entry of column) ... will handle exceptions later
        try:
                for col in columns:
                        try:
                                float(individual_rows[0].get(col))
                                col_json.append({'type': 'number'})
                        #need to figure out why ValueError exception is not being caught
                        except:
                                col_json.append({'type': 'string'})
        except:
                #This is hard coded so needs to be fixed
                col_json.append({'label': 'sample', 'type': 'string'})
                col_json.append({'label': 'dbsnp', 'type': 'number'})
                col_json.append({'label': 'singl', 'type': 'number'})
                col_json.append({'label': 'company', 'type': 'string'})

        row_json = []

        #ADDRESS
        #hardcoded
        for indiv in individual_rows:
                row_json.append({'c': [{'v': str(indiv["sample"])},{'v': float(indiv["dbsnp_ins_del_ratio"])}, {'v': float(indiv["num_singletons"])}, {'v': str(indiv["company"])}]});
                #row_json.append({'c': [{'v': str(indiv["date"])},{'v': indiv["value"]}]});
                #break

        final_json = {'cols': col_json, 'rows': row_json}
        #print(json.dumps(final_json))

        return JSONResponse(json.dumps(final_json))
        #return JSONResponse({"cols": [{"type":"string"},{"type":"number"}], "rows":[{"c":[{"v":"2015-04-01"},{"v":17}]}] })
