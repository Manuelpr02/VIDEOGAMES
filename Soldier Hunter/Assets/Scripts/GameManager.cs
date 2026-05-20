using UnityEngine;
using UnityEngine.SceneManagement; // Necesario para reiniciar el nivel

public class GameManager : MonoBehaviour
{
    // Esta función la llamaremos desde el script del personaje cuando sus vidas lleguen a 0
    public void ReiniciarNivel()
    {
        Debug.Log("El personaje ha muerto. Reiniciando...");

        // Obtenemos el nombre de la escena actual y la cargamos de nuevo
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}