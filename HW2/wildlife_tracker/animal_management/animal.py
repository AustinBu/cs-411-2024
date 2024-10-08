from typing import Any, Optional

class Animal:
    animal_id: int
    species: str
    age: Optional[int]
    health_status: Optional[str]

    def __init__(self, 
                 animal_id,
                 species,
                 age=None,
                 health_status=None):
        self.animal_id = animal_id
        self.age = age
        self.health_status = health_status
        self.species = species

