package approval

import rego.v1

high_impact_types := {
    "google_project_iam_binding",
    "google_project_iam_member",
    "google_organization_iam_member",
    "google_folder_iam_member",
    "google_compute_firewall",
    "google_kms_crypto_key",
    "google_sql_database_instance",
    "google_container_cluster",
    "google_org_policy_policy",
    "google_project",
    "google_service_account",
}

deletions contains rc.address if {
    some rc in input.resource_changes
    "delete" in rc.change.actions
}

high_impact_changes contains rc.address if {
    some rc in input.resource_changes
    rc.type in high_impact_types
    not rc.change.actions == ["no-op"]
    not rc.change.actions == ["read"]
}

default additional_approval_required := false

additional_approval_required if count(deletions) > 0
additional_approval_required if count(high_impact_changes) > 0

reasons contains sprintf("DELETE/REPLACE: %s", [a]) if some a in deletions
reasons contains sprintf("HIGH IMPACT: %s", [a]) if some a in high_impact_changes
