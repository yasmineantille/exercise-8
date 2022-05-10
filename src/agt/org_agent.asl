// Agent acting_agent in project exercise-8

// Agent org_agent in project exercise-8

/* Initial beliefs and rules */
org_name("lab_monitoring_org").
group_name("monitoring_team").
sch_name("monitoring_scheme").

// Credits to Marc because without him I wouldn't have found the following method.
has_enough_players_for(R) :-
  role_cardinality(R, Min, Max) &
  .count(play(_,R,_),NP) &
  NP >= Min.

/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : org_name(OrgName) &
  group_name(GroupName) &
  sch_name(SchemeName)
<-
  .print("I will initialize an organization ", OrgName, " with a group ", GroupName, " and a scheme ", SchemeName, " in workspace ", OrgName);
  // Task 1 Step 2
  makeArtifact("crawler", "tools.HypermediaCrawler", ["https://api.interactions.ics.unisg.ch/hypermedia-environment/was/581b07c7dff45162"], CrawlerId);
  searchEnvironment("Monitor Temperature", DocumentPath);
  .print("Document for the relationType Monitor Temperature found: ", DocumentPath);

  // Task 1 Step 3
  makeArtifact(OrgName, "ora4mas.nopl.OrgBoard", [DocumentPath], OrgArtId);
  focus(OrgArtId);

  // Task 1 Step 4
  createGroup(GroupName, GroupName, GrpArtId);
  //createGroup(GroupName, "ora4mas.nopl.GroupBoard", GrpArtId);
  focus(GrpArtId);
  //makeArtifact(GroupName, "ora4mas.nopl.GroupBoard", ["src/org/auction-os.xml"], GrpArtId);
  createScheme(SchemeName, SchemeName, SchemeArtId);
  //createScheme(SchemeName, "ora4mas.nopl.SchemeBoard", SchemeArtId);
  focus(SchemeArtId);

  // Task 1 Step 5
  .broadcast(tell, organizationDeployed(OrgName, GroupName, SchemeName));
  // .broadcast(tell, organizationDeployed(OrgName));   // Would it be enough to just send the Org without Group?

  // Task 1 Step 6
  //?formationStatus(ok).
  !manage_formation(OrgName).

// Task 2 Step 3
+!manage_formation(OrgName) : role(R,_) & not has_enough_players_for(R)
<-
  .broadcast(tell, roleAvailable(R, OrgName));
  .print("Looking for role: ", R);
  .wait(15000);
  !manage_formation(OrgName).

+!manage_formation(OrgName) : formationStatus(ok)
<-
  .print("Group is well-formed.").


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
{ include("$moiseJar/asl/org-rules.asl") }
