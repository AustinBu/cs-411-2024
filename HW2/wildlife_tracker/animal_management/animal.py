from typing import Any, Optional

class Animal:
    animal_id: int
    species: str
    current_date: str
    age: Optional[int]
    health_status: Optional[str]

    def __init__(self, 
                 animal_id,
                 species,
                 current_date,
                 age=None,
                 health_status=None):
        self.animal_id = animal_id
        self.age = age
        self.current_date = current_date
        self.health_status = health_status
        self.species = species

    def get_animal_details(self) -> dict[str, Any]:
        pass

    def update_animal_details(self, int, **kwargs: Any) -> None:
        pass
