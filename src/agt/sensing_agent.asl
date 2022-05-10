// Agent sensing_agent in project exercise-8

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
<-
	.my_name(Me);
	.print("Hello from ",Me).

// Plan to achieve reading the air temperature using a robotic arm
+!read_temperature : true <-
  // Task 3 Step 1
	.print("Reading temperature...");
  makeArtifact("weatherStation", "wot.ThingArtifact", ["https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/weather-station.ttl"], WeatherStationId);
	//focus(WeatherStationId);
	readProperty("Temperature", _, Temperature);
	.broadcast(tell, temperatureReading(Temperature));
	.print("Mock temperature reading (Celcious): ", Temperature).

// Task 2 Step 1
+organizationDeployed(OrgName, GroupName, SchemeName) : true <-
		.print("Joining deployed organisation: ", OrgName);
		lookupArtifact(OrgName, OrgArtId);
		focus(OrgArtId);
		lookupArtifact(GroupName, GrpArtId);
		focus(GrpArtId);
		// I think Scheme isn't necessary here?
		//lookupArtifact(SchemeName, SchemeArtId);
		//focus(SchemeArtId);
		!reasonAndAdoptRoles.

// Task 2 Step 2
// TODO is this all that needs to be done here?
+!reasonAndAdoptRoles : role(R, _) & i_have_plans_for(R)
<-
	.print("Adopting role: ", R);
	adoptRole(R).

+roleAvailable(R, OrgName): true
<-
  lookupArtifact(OrgName, OrgArtId);
  focus(OrgArtId);
  !reasonAndAdoptRoles.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
