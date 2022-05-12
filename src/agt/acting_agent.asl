// Agent acting_agent in project exercise-8

/* Initial beliefs and rules */
role_goal(R, G) :-
	role_mission(R, _, M) & mission_goal(M, G).

can_achieve (G) :-
	.relevant_plans({+!G[scheme(_)]}, LP) & LP \== [].

i_have_plans_for(R) :-
	not (role_goal(R, G) & not can_achieve(G)).

/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : true
<- 	.my_name(Me);
	.print("Hello from ",Me).

// Plan to achieve manifesting the air temperature using a robotic arm
+!manifest_temperature : temperatureReading(TempValue)
<-
	// Task 3 Step 3
  makeArtifact("converter", "tools.Converter", [], ConArtId);
	focus(ConArtId);
	convert(TempValue, -20, 200, 30, 830, RescaledValue);
	.print("Temperature value rescaled: ", RescaledValue);
	// .print("Mock temperature manifesting");

	// Task 3 Step 4
	makeArtifact("robot", "wot.ThingArtifact", ["https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/leubot1.ttl"], RobotId);
  setAPIKey("6f190351c8b12abfc209796400548b2f");
  invokeAction("setWristAngle", ["value"], [RescaledValue]).

// Task 2 Step 4
+organizationDeployed(OrgName, GroupName, SchemeName) : true <-
	.print("Joining deployed organisation: ", OrgName);
	lookupArtifact(OrgName, OrgArtId);
	focus(OrgArtId);
	lookupArtifact(GroupName, GrpArtId);
	focus(GrpArtId);
	!reasonAndAdoptRoles.

+!reasonAndAdoptRoles : role(R, _) & i_have_plans_for(R)
<-
  .print("Adopting role: ", R);
	adoptRole(R).

+roleAvailable(R, OrgName): true
<-
  lookupArtifact(OrgName, OrgArtId);
  focus(OrgArtId);
  !reasonAndAdoptRoles.


+obligation(Ag, MCond, committed(Ag,Mission,Scheme), Deadline) :
  .my_name(Ag)
  <-
  .print("My obligation is ", Mission);
  commitMission(Mission)[artifact_name(Scheme)];
  lookupArtifact(Scheme, SchemeArtId);
  focus(SchemeArtId).

+obligation(Ag, MCond, done(Scheme,Goal,Ag), Deadline) :
  .my_name(Ag)
  <-
  .print("My goal is ", Goal);
  !Goal[scheme(Scheme)];
  goalAchieved(Goal)[artifact_name(Scheme)].


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
