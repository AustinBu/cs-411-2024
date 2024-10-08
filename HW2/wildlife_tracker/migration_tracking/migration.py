from typing import Any

from wildlife_tracker.migration_tracking.migration_path import MigrationPath

class Migration:
    migration_id: int
    migration_path: MigrationPath
    status: str
    start_date: str
    current_location: str


    def __init__(self, 
                 migration_id,
                 migration_path,
                 start_date,
                 current_location,
                 status = "Scheduled"):
        self.migration_id = migration_id
        self.migration_path = migration_path
        self.start_date = start_date
        self.current_location = current_location
        self.status = status

    def get_migration_details(self) -> dict[str, Any]:
        pass

    def update_migration_details(self, **kwargs: Any) -> None:
        pass