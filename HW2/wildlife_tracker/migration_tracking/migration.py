from typing import Any

from wildlife_tracker.migration_tracking.migration_path import MigrationPath

class Migration:
    migration_id: int
    migration_path: MigrationPath
    status: str

    def __init__(self, 
                 migration_id,
                 migration_path,
                 status = "Scheduled"):
        self.migration_id = migration_id
        self.migration_path = migration_path
        self.status = status