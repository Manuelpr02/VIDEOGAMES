using UnityEngine;

public class HeroeAI : MonoBehaviour
{
    [Header("Configuración de Movimiento")]
    public float velocidad = 3f;
    public Transform puntoA;
    public Transform puntoB;
    private Vector3 destinoActual;

    [Header("Detección y Ataque")]
    public Transform jugador;
    public float rangoDeteccion = 10f;
    public GameObject proyectilPrefab;
    public Transform puntoDisparo;
    public float cadenciaFuego = 1.5f;
    private float cronometroDisparo;

    // Referencia al componente Animator
    private Animator anim;

    void Start()
    {
        anim = GetComponent<Animator>();
        destinoActual = puntoB.position;
    }

    void Update()
    {
        float distanciaAlJugador = Vector2.Distance(transform.position, jugador.position);

        if (distanciaAlJugador < rangoDeteccion)
        {
            AtacarJugador();
        }
        else
        {
            Patrullar();
        }
    }

    void Patrullar()
    {
        // Avisamos al Animator que NO estamos disparando (por lo tanto, corre)
        if (anim != null) anim.SetBool("Disparando", false);

        // Moverse hacia el punto de patrulla
        transform.position = Vector2.MoveTowards(transform.position, destinoActual, velocidad * Time.deltaTime);

        // Girar el sprite según la dirección
        if (destinoActual.x > transform.position.x) transform.localScale = new Vector3(1, 1, 1);
        else transform.localScale = new Vector3(-1, 1, 1);

        // Cambiar de destino al llegar
        if (Vector2.Distance(transform.position, destinoActual) < 0.2f)
        {
            destinoActual = (destinoActual == puntoA.position) ? puntoB.position : puntoA.position;
        }
    }

    void AtacarJugador()
    {
        // Avisamos al Animator que SI estamos disparando (se detiene y hace la animación)
        if (anim != null) anim.SetBool("Disparando", true);

        // Mirar hacia el jugador
        if (jugador.position.x > transform.position.x) transform.localScale = new Vector3(1, 1, 1);
        else transform.localScale = new Vector3(-1, 1, 1);

        // Disparar cada cierto tiempo
        cronometroDisparo += Time.deltaTime;
        if (cronometroDisparo >= cadenciaFuego)
        {
            Instantiate(proyectilPrefab, puntoDisparo.position, Quaternion.identity);
            cronometroDisparo = 0;
        }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, rangoDeteccion);
    }
}