/*************************************************************************************************
* This file is part of the Nebula Framework project, released under the MIT License.             *
* See LICENSE file or go to https://github.com/jongpie/NebulaFramework for full license details. *
*************************************************************************************************/
public abstract class SobjectRepository extends Dml implements ISobjectRepository, IDml {

    private List<Schema.SobjectField> sobjectFieldList;
    private Map<String, Schema.SobjectField> sobjectFieldMap;
    private Soql.QueryField idQueryField;

    public SobjectRepository() {
        this.currentModule = NebulaCore.Module.REPOSITORY;

        this.sobjectFieldMap = this.getSobjectType().getDescribe().fields.getMap();
        this.idQueryField    = new Soql.QueryField(this.getField('Id'));
    }

    public override abstract Schema.SobjectType getSobjectType();

    // SOQL
    public virtual Sobject getById(Id recordId) {
        return new Soql(this.getSobjectType())
            .filterWhere(new Soql.QueryFilter(this.idQueryField, '=', recordId))
            .getFirstQueryResult();
    }

    public virtual List<Sobject> getById(List<Id> recordIds) {
        return new Soql(this.getSobjectType())
            .filterWhere(new Soql.QueryFilter(this.idQueryField, 'IN', recordIds))
            .getQueryResults();
    }

    public virtual List<Sobject> get(Soql.QueryFilter queryFilter) {
        return this.get(new List<Soql.QueryFilter>{queryFilter});
    }

    public virtual List<Sobject> get(List<Soql.QueryFilter> queryFilters) {
        return new Soql(this.getSobjectType())
            .filterWhere(queryFilters)
            .getQueryResults();
    }

    public virtual List<Sobject> getByIdAndQueryFilters(Set<Id> idSet, List<Soql.QueryFilter> queryFilters) {
        return this.getByIdAndQueryFilters(new List<Id>(idSet), queryFilters);
    }

    public virtual List<Sobject> getByIdAndQueryFilters(List<Id> idList, List<Soql.QueryFilter> queryFilters) {
        return new Soql(this.getSobjectType())
            .filterWhere(new Soql.QueryFilter(this.idQueryField, 'IN', idList))
            .filterWhere(queryFilters)
            .getQueryResults();
    }

    // SOSL
    public virtual List<Sobject> getSearchResults(String searchTerm) {
        return this.getSearchResults(searchTerm, Sosl.SearchGroup.ALL_FIELDS, null);
    }

    public virtual List<Sobject> getSearchResults(String searchTerm, Sosl.SearchGroup searchGroup) {
        return this.getSearchResults(searchTerm, searchGroup, null);
    }

    public virtual List<Sobject> getSearchResults(String searchTerm, Sosl.SearchGroup searchGroup, List<Soql.QueryFilter> queryFilters) {
        return new Sosl(searchTerm, new Soql(this.getSobjectType()).filterWhere(queryFilters))
            .inSearchGroup(searchGroup)
            .getFirstSearchResults();
    }

    private Schema.SobjectField getField(String fieldName) {
        return this.sobjectFieldMap.get(fieldName);
    }

}