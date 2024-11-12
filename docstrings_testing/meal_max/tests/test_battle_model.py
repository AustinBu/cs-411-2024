import pytest

from unittest.mock import patch, MagicMock 
from meal_max.models.battle_model import BattleModel
from meal_max.models.kitchen_model import Meal 

######################################################
#
#    Fixtures
#
######################################################

@pytest.fixture 
def battle_model(): 
    """Fixture to provide a new instance of BattleModel for each test."""
    return BattleModel() 

@pytest.fixture
def mock_update_meal_stats(mocker): 
    """Mock the update_meal_stats function for testing.""" 
    return mocker.patch("meal_max.models.battle_model.update_meal_stats")

@pytest.fixture 
def combatant1(): 
    return Meal(id = 1, meal = "Meal 1", price = 10.0, cuisine = "Italian", difficulty = "MED")

@pytest.fixture
def combatant2():
    return Meal(id = 2, meal = "Meal 2", price = 15.0, cuisine = "Mexican", difficulty = "LOW")

######################################################
#
#    Add and delete 
#
######################################################

def test_prep_combatant(battle_model, combatant1): 
    """Test adding combatant to BattleModel.""" 
    battle_model.prep_combatant(combatant1)
    assert len(battle_model.combatants) == 1
    assert battle_model.combatants[0].meal == "Meal 1"

def test_prep_combatant_when_full(battle_model, combatant1, combatant2): 
    """Test adding combatant when list is already full raises an error.""" 
    battle_model.prep_combatant(combatant1)
    battle_model.prep_combatant(combatant2) 
    with pytest.raises(ValueError, match="Combatant list is full, cannot add more combatants."):
        battle_model.prep_combatant(combatant1)

def test_clear_combatants(battle_model, combatant1, combatant2): 
    """Test clearing combatants list."""
    battle_model.combatants.extend([combatant1, combatant2])
    battle_model.clear_combatants()
    assert len(battle_model.combatants) == 0

######################################################
#
#    Get combatants 
#
######################################################

def test_get_combatants(battle_model, combatant1): 
    """Test gettign current list of combattants.""" 
    battle_model.prep_combatant(combatant1)
    combatants = battle_model.get_combatants()
    assert len(combatants) == 1
    assert combatants[0].meal == "Meal 1"


######################################################
#
#    Battle Execution 
#
######################################################

def test_battle(battle_model, mock_update_meal_stats, combatant1, combatant2):
    """Test the battle function between two combatants."""
    with patch("meal_max.models.battle_model.get_random", return_value=0.05):
        battle_model.combatants = [combatant1, combatant2]
        winner = battle_model.battle()

        # Ensure that the correct winner is selected based on mock
    assert winner in ["Meal 1", "Meal 2"]
    mock_update_meal_stats.assert_any_call(battle_model.combatants[0].id, 'win')
    mock_update_meal_stats.assert_any_call(combatant2.id, 'loss')

def test_battle_with_insufficient_combatants(battle_model): 
    """Test that a battle cannot be started with fewer than two combatants."""
    with pytest.raises(ValueError, match = "Two combatants must be prepped for a battle."):
        battle_model.battle()

######################################################
#
#    Battle Score
#
######################################################

def test_get_battle_score(battle_model, combatant1): 
    """Test calculating battle score for a combatant.""" 
    score = battle_model.get_battle_score(combatant1) 
    expected_score = (combatant1.price * len(combatant1.cuisine)) - 2
    assert score == expected_score, f"Expected score to be {expected_score} but got {score}"