using UnityEngine;

public class MuerteCaida : MonoBehaviour
{
    private void OnTriggerEnter2D(Collider2D collision)
    {
        // Si lo que cae es el jugador
        if (collision.CompareTag("Player"))
        {
            MovimientoEnemigo jugador = collision.GetComponent<MovimientoEnemigo>();
            if (jugador != null)
            {
                // Llamamos a una nueva función que lo teletransporta
                jugador.CaidaAlVacio();
            }
        }
    }
}