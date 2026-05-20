using UnityEngine;

public class Checkpoint : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            // Le decimos al jugador que este es su nuevo punto de reaparición
            MovimientoEnemigo jugador = collision.GetComponent<MovimientoEnemigo>();
            if (jugador != null)
            {
                jugador.ActualizarCheckpoint(transform.position);
                Debug.Log("¡Checkpoint alcanzado!");
            }
        }
    }
}