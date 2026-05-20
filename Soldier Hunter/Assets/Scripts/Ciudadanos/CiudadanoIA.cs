using UnityEngine;

public class CiudadanoIA : MonoBehaviour
{
    [Header("Configuración Movimiento")]
    public float velocidad = 2f;
    public float distanciaPatrulla = 3f;

    private Vector3 posicionInicial;
    private int direccion = 1;
    private SpriteRenderer spriteRenderer;

    void Start()
    {
        posicionInicial = transform.position;
        spriteRenderer = GetComponent<SpriteRenderer>();

        // Asegúrate de que el ciudadano tenga este Tag
        gameObject.tag = "Heroe";
    }

    void Update()
    {
        // Calculamos los límites
        float limiteDerecho = posicionInicial.x + distanciaPatrulla;
        float limiteIzquierdo = posicionInicial.x - distanciaPatrulla;

        // Cambiar dirección al tocar los bordes
        if (transform.position.x >= limiteDerecho) direccion = -1;
        if (transform.position.x <= limiteIzquierdo) direccion = 1;

        // Mover el objeto
        transform.Translate(Vector2.right * direccion * velocidad * Time.deltaTime);

        // Girar el sprite
        if (spriteRenderer != null)
        {
            spriteRenderer.flipX = (direccion < 0);
        }
    }

    // Dibujar los límites en el editor para que sea fácil de ajustar
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.green;
        Vector3 dcha = new Vector3(posicionInicial.x + distanciaPatrulla, transform.position.y, 0);
        Vector3 izq = new Vector3(posicionInicial.x - distanciaPatrulla, transform.position.y, 0);
        Gizmos.DrawLine(izq, dcha);
    }
}