from typing import Optional, Any

from wildlife_tracker.habitat_management.habitat import Habitat

class MigrationPath:
    start_location: Habitat
    destination: Habitat
    path_id: int
    duration: Optional[int] = None
    species: str

    def __init__(self, 
                 path_id,
                 start_location,
                 destination,
                 species,
                 duration=None):
        self.path_id = path_id
        self.start_location = start_location
        self.destination = destination
        self.species = species
        self.duration = duration

    def get_migration_details(self) -> dict[str, Any]:
        pass

    def update_migration_path_details(self, **kwargs) -> None:
        pass

    