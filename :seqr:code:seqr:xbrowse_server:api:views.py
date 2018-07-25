@csrf_exempt
@login_required
@log_request('alyssa')
def alyssa(request):
        cursor = connection.cursor()
        #cursor.execute("SELECT * from gc_1")
        cursor.execute("SELECT sample, company, dbsnp_ins_del_ratio, num_singletons, mean_target_coverage, median_target_coverage, pct_target_bases_10x, pct_target_bases_20x, pct_target_bases_30x, pct_chimeras, contamination, het_homvar_ratio, total_snps, pct_dbsnp, dbsnp_titv, novel_titv, total_indels, pct_dbsnp_indels, novel_ins_del_ratio, project_id, family_id FROM gc_2 ORDER BY company")
        columns = [col[0] for col in cursor.description]
        individual_rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        individuals_json = []

        col_json = []

        #ADDRESS
        #Column type determined by type(first row entry of column) ... will handle exceptions later
        for col in columns:
                try:
                        float(individual_rows[0].get(col))
                        col_json.append({'type': 'number'})
                #need to figure out why ValueError exception is not being caught
                except:
                        col_json.append({'type': 'string'})
        row_json = []
        trial_row = []

        for indiv in individual_rows:
                row_json.append({'c': [{'v': str(indiv[str(c)] )} for c in columns] });

        final_json = {'cols': col_json, 'rows': row_json, 'col_names': columns}
        #print(json.dumps(final_json))

        return JSONResponse(json.dumps(final_json))
        #return JSONResponse({"cols": [{"type":"string"},{"type":"number"}], "rows":[{"c":[{"v":"2015-04-01"},{"v":17}]}] })