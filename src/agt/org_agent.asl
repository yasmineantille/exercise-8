// Agent acting_agent in project exercise-8

// Agent org_agent in project exercise-8

/* Initial beliefs and rules */
org_name("lab_monitoring_org").
group_name("monitoring_team").
sch_name("monitoring_scheme").

/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : org_name(OrgName) &
  group_name(GroupName) &
  sch_name(SchemeName)
<-
  .print("I will initialize an organization ", OrgName, " with a group ", GroupName, " and a scheme ", SchemeName, " in workspace ", OrgName);
  // Step 2
  makeArtifact("crawler", "tools.HypermediaCrawler", ["https://api.interactions.ics.unisg.ch/hypermedia-environment/was/581b07c7dff45162"], CrawlerId);
  searchEnvironment("Monitor Temperature", DocumentPath);
  .print("Document for the relationType Monitor Temperature found: ", DocumentPath);

  // Step 3
  makeArtifact(OrgName, "ora4mas.nopl.OrgBoard", [DocumentPath], OrgArtId);
  focus(OrgArtId);

  // Step 4
  createGroup(GroupName, GroupName, GrpArtId);
  //createGroup(GroupName, "ora4mas.nopl.GroupBoard", GrpArtId);
  focus(GrpArtId);
  //makeArtifact(GroupName, "ora4mas.nopl.GroupBoard", ["src/org/auction-os.xml"], GrpArtId);
  createScheme(SchemeName, SchemeName, SchemeArtId);
  //createScheme(SchemeName, "ora4mas.nopl.SchemeBoard", SchemeArtId);
  focus(SchemeArtId);

  // Step 5
  .broadcast(tell, organizationDeployed(OrgName));
  // .broadcast(tell, organizationDeployed(OrgName, GroupName, SchemeName));

  // Step 6
  ?formation(ok)[artifact_id(GrpArtId)].


// Plan to add an organization artifact to the inspector_gui
// You can use this plan after creating an organizational artifact so that you can inspect it
+!inspect(OrganizationalArtifactId) : true
<-
  debug(inspector_gui(on))[artifact_id(OrganizationalArtifactId)].

// Plan to wait until the group managed by the Group Board artifact G is well-formed
// Makes this intention suspend until the group is believed to be well-formed
+?formationStatus(ok)[artifact_id(G)] : group(GroupName,_,G)[artifact_id(OrgName)]
<-
  .print("Waiting for group ", GroupName," to become well-formed")
  .wait({+formationStatus(ok)[artifact_id(G)]}).

// Plan to react on events about an agent Ag adopting a role Role defined in group GroupId
+play(Ag, Role, GroupId) : true
<-
  .print("Agent ", Ag, " adopted the role ", Role, " in group ", GroupId).

// Additional behavior
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
//{ include("$moiseJar/asl/org-rules.asl") }
