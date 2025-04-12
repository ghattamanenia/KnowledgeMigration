public with sharing class OpportunityTeamMemberDAO {
    
    public static List<OpportunityTeamMember> getRecByOppId(Id OppId){
        return [SELECT
                        Name,
                        TeamMemberRole
                FROM
                        OpportunityTeamMember
                WHERE
                        OpportunityId = :oppId
        ];
    }
}